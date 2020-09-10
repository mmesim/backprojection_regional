function clr=mkfitpoly2nd(nd,maxdegree,accuracy,dowrite);
% mkfitpoly2nd.......fit layer polynomials to discrete velocity model#
%
% call: clr=mkfitpoly2nd(nd,maxdegree,accuracy);
%       clr=mkfitpoly2nd(nd,maxdegree,accuracy,'dowrite');
%
%      nd: (structure array)
%             velocity model in ND format, as returned by MKREADMODEL
%
%      maxdegree: maximum polynomial degree to be used for fitting
%                 The program tries to find the smallest degree sufficient
%                 for a good fit
%
%      accuracy: accuracy in digits to which the input parameters shall be
%                reproduced
%
%
%
%      'dowrite': if present, tables of the polynomial coefficients are
%                 written to the screen.
%
% result: clr: (structure)
%              CLR model structure as returned by MKREADCLR, containing a
%              polynomial fit to the discrete model given in nd.
%
%
% This routine subdivides the model ND at the given discontinuities and
% fits polynomials with the given degree, using matlab's polyfit.
%
% Martin Knapmeyer, 05.02.2008, 06.02.2008, 26.05.2008, 30.05.2008
%
% BUGS & LIMITATIONS: does not really work. But was sufficient to construct
%                     polynomials for the one model and purpose I needed
%                     them for... MK07022008
%
%                     the routine does not yet transfer discontinuity names
%                     into the proper fields of the CLR struct.
%
%                     The routine does not recognize discontinuities that
%                     are not listed in the standard discontinuities fields
%                     or in the .dz field of the model structure.
%
%                     DOES NOT YET WRITE THE CLR STRUCTURE!





%%%%%% first step: identify discontinuities in OLDMODEL
%%%%%%             As discontinuity, we define any case in which the same depth sample
%%%%%%             appears twice. This might be the case at velocity jumps or at places
%%%%%%             where v(z) has a kink and the first derivative jumps.
%%%%%%             This is not done by MKREADND, so we have to do it here.
%%%%%%             The identification is simple: whenever the difference between
%%%%%%             adjacent depth samples is zero, we have a discontinuity.
%%%%%%             we assume that all depth samples are ordered by depth
%%%%%%             properly!
z=nd.z;
deltaz=diff(z);
disconindies=find(deltaz==0); % array index to discontinuities: points to the upper sample
disconcnt=length(disconindies); % number of discontinuities
discondepths=z(disconindies); % depths of discontinuities
disp(['MKFITPOLY2ND: detected layers: ' int2str(length(discondepths)+1)]);
disp('----------------------------------------------------------------');

if nargin==4
   tablehead='Qty |   Zmin  |  Zmax   |deg|dig| Polynomial';
else
   tablehead='Qty | Layer | x range         |  degree  |  digits  | fitted digits';
end; % if nargin
disp(tablehead);

%%% add surface and planet center to discontinuity list
dz=[0; discondepths; nd.rp];

%%% identify all discontinuities, plus planet's center
%dz=[0; nd.conr; nd.moho; nd.d410; nd.d520; nd.d660; nd.cmb; nd.icb; nd.dz'; nd.rp];

%%% transform z into normailzed radius as used for PREM
nd.z=(nd.rp-nd.z)/nd.rp;

%%% transform discontinuity depths into normalized radius
dzsav=dz; % save for later use - without rounding problems
dz=(nd.rp-dz)/nd.rp;

%%% remove all NaNs
dzsav=dzsav(~isnan(dzsav));
dz=dz(~isnan(dz));


%%% plot velocity model for later comparisons
figure(2);
clf;
figure(1);
clf;
plot(nd.vp,nd.rp-nd.z*nd.rp,'b.-');
hold on
plot(nd.vs,nd.rp-nd.z*nd.rp,'r.-');
plot(nd.rho,nd.rp-nd.z*nd.rp,'m.-');
plot(nd.qp,nd.rp-nd.z*nd.rp,'k.-');
plot(nd.qs,nd.rp-nd.z*nd.rp,'g.-');
hold off
axis ij


warning off


%%% loop over all quantities
quantities=strvcat(' Vp',' Vs','Rho'); %,' Qp',' Qs');
quantico=size(quantities,1);
coeffcount=0; % count total number of coeffcients
for quantitynr=1:quantico
   
   quantity=quantities(quantitynr,:); % string used in screen output
   switch quantitynr
      case {1}
         qty=nd.vp;
      case {2}
         qty=nd.vs;
      case {3}
         qty=nd.rho;
      case {4}
         qty=nd.qp;
      case {5}
         qty=nd.qs;
   end; % switch

   %%% loop over discontinuities
   disccnt=length(dz);
   for discindy=2:disccnt

      %%% identify sample indices of this layer
      topdepth=dz(discindy-1);
      bottomdepth=dz(discindy);
      samples=find((nd.z<=topdepth)&(nd.z>=bottomdepth));
%       samples=samples(2:(end-1)); % removes double depths at both ends
      if nd.z(samples(1))==nd.z(samples(2))
         samples=samples(2:end);
      end; % if samples(1)==samples(2)
      if nd.z(samples(end-1))==nd.z(samples(end))
         samples=samples(1:end-1);
      end; % samples(end-1)==samples(end)
      x=nd.z(samples);

      %%%%%% fit polynomial from the above discontinuity down to the current one

            %%% identify samples of this layer
            y=qty(samples);

            %%% mark layer in plot
            hold on
            %plot([min(y) max(y)],[1 1]*topdepth,'k-');
            %plot([min(y) max(y)],[1 1]*bottomdepth,'k-');
            plot([min(qty(:)) max(qty(:))],nd.rp-[1 1]*topdepth*nd.rp,'k-');
            plot([min(qty(:)) max(qty(:))],nd.rp-[1 1]*bottomdepth*nd.rp,'k-');
            plot(y,nd.rp-x*nd.rp,'bo');
            hold off

            %%% init misfit list
            misfit=zeros(size(2:disccnt))+inf;
            unfit=misfit';
            polydigits=misfit'; % number of digits needed in each polynomial

            %%% loop over polynomial degree, to find the smallest sufficient degree
            degree=0;
            done=0;
            while done==0
               
               %%% only if polynomial is not underdetermined
               if degree<length(y)
               
               %%% loop over polynomial coefficients number of digits
               %%% to find the smallest amount of necessary digits
               digits=1;
               maxdigits=8; % maximum number of digits in output
               digitsfound=0;
               while digitsfound==0

                  

                     %%% construct polynomial
                     %%% first coeffcient is for highest power!
                     poly=polyfit(x,y,degree);

                     %%% round polynomial coefficients
                     %%% if a coeff is exactly 0, then the determination of the number
                     %%% of digits left of the dot yields inf. These must be replaced
                     %%% by something more meaningful.
                     poly=mkroundcoeff(poly,digits);


%                      %%% plot polynomial
%                      figure(1);
%                      hold on
%                      plot(polyval(poly,x),nd.rp-x*nd.rp,'ko-');
%                      hold off
%                      drawnow

                     %%% determine misfit
                     %%% The misfit is the maximum deviation between the given samples and
                     %%% the rounded polynomial approximation of their values.
                     %%% this is a measure in the units of the interpolated quantity,
                     %%% not a relative measure!!
                     %%% The reason for this definition is that any number of
                     %%% the input modell shall be reproduced with a given
                     %%% accuracy, therefor the worst fit must be taken as
                     %%% measure.
                     fitoutput=polyval(poly,x);
                     fiterror=abs(y-fitoutput);
                     [misfit(degree+1),worstone]=max(fiterror);

                     %%% convert misfit into number of reproduced digits
                     %%% (negative to be a quantity to minimize)
                     unfit(degree+1)=-(-(log10(misfit(degree+1)/y(worstone))));
                     polydigits(degree+1)=digits;
                     
                     


                     %%% is the fit good enough? otherwise increase number of digits
                     %%% used in polynomial coefficients
                     if (digits<maxdigits)&(unfit(degree+1)>-accuracy)
                        digits=digits+1;
                     else
                        %disp([int2str(degree) ', ' int2str(polydigits(degree+1)) ': ' num2str(unfit(degree+1))]);
                        digitsfound=1;
                     end
                  
                  end; % while

                  
                  %%% is the fit good enough? otherwise increase degree!
                  if (degree==maxdegree)|(unfit(degree+1)<-accuracy)
                     %%% degree exhaust!
                     done=1;
                  end; % if degree==maxdegree
                  degree=degree+1;


               else
                  %%% not enough data points for hihger degrees!
                  done=1;
               end; % if degree<length(y)

            end; % while done
            
            
            figure(3);
            hold on
            plot((1:length(unfit))-1,unfit,'.-');
            hold off
            ylabel('unfitted digits');
            xlabel('polynomial degree');
            figure(1);


            %%% identify degree with smallest misfit and reconstruct
            %%% polynomial with smallest misfit
            [minimisfit,bestindy]=min(unfit);
            bestdegree=bestindy-1; % first element is degree 0!
            significantdigits=polydigits(bestindy);
            poly=polyfit(x,y,bestdegree);
            poly=mkroundcoeff(poly,polydigits(bestindy));



            %%% plot polynomial
            figure(1);
            hold on
            plot(polyval(poly,x),nd.rp-x*nd.rp,'ko');
            finex=sort([x; (min(x):(abs(max(x)-min(x))/100):max(x))']);
            plot(polyval(poly,...
                         finex),...
                         nd.rp-finex*nd.rp,...
                         'k-');
            hold off

            %%% write polynomial to screen, if requested
            if nargin==4
               %%% table requested
               
               %%% construct format string for screen output
               %%% begn with format for the depths
               format='%8.3f  %8.3f  '; % this is for the depth entries
               format=[format '%2.1d  %2.1d  ']; % this is for degree and number if significant digits
               %%% append a coefficient format for each coeff, depending on degree
               %%% and also depending on number of significant digits
               coeff=['%+' int2str(2*significantdigits+2) '.' int2str(significantdigits) 'f'];
               for indy=1:(bestdegree+1)
                   format=[format ' ' coeff 'x' int2str(indy-1)];
               end; % for indy
               %%% finally, append a format for the output of he misfit measure
               format=[format ' | (+/- %8.6f)'];

               %%% re-read topdepth and bottomdepth from saved list - do output in km!
               %%% flip coefficient list: constant term first, highest
               %%% power last.
               topdepth=dzsav(discindy-1);
               bottomdepth=dzsav(discindy);
               disp([quantity ': ' sprintf(format,...
                                           topdepth,bottomdepth,...
                                           bestdegree,significantdigits,...
                                           fliplr(poly),minimisfit)]);
               coeffcount=coeffcount+length(poly);

            else

               %%% no polynomial table requested - print best degree and
               %%% misfit only
%                disp([quantity ' layer ' int2str(discindy-1),...
%                      ' (' num2str(min(x),3) '-' num2str(max(x),3) '): ',...
%                      ' best degree: ' int2str(bestdegree),...
%                      ' polynomial digits: ' int2str(significantdigits),...
%                      ' fitted digits: ',...
%                      int2str(-unfit(bestindy))]); %num2str(abs(max((y-polyval(poly,x)))),'%10.8f')]);
               format='%s |  %2.1d   | (%5.4f-%5.4f) |    %2.1d    |    %2.1d    |      %s';
               disp(sprintf(format,...
                            quantity,...
                            discindy-1,...
                            min(x),...
                            max(x),...
                            bestdegree,...
                            significantdigits,...
                            int2str(-unfit(bestindy))));
                coeffcount=coeffcount+length(poly);
                
                figure(2);
                hold on
                plot3(significantdigits,-unfit(bestindy),discindy-1,'+');
                hold off
                xlabel('Significant Digits');
                ylabel('Fitted Digits');
                zlabel('Layer');
                figure(1);

            end; % if nargin

      %%%%%% polynomial fitting done


   end; % for disccnt
   
   disp('----------------------------------------------------------------');
   disp(tablehead);

end; % for quantityno


warning on


disp(['MKFITPOLY2ND: ',...
      int2str(coeffcount) ' coefficients ',...
      'generated to fit ',...
      int2str(length(nd.z)*quantico) ' original depth samples.']);

return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        helper functions                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function roundpoly=mkroundcoeff(poly,digits);
% mkroudncoeff.....round polynomial coeff to given number if significant digits
%
% call: roundpoly=mkroundcoeff(poly,digits);
%
%       poly: list of polynomial coefficients
%
%       digits: desired number of significant digits
%
% result: roundpoly: as POLY, but all numerical values reduced to DIGITS
%                    significant digits
%
% Martin Knapmeyer, 08.02.2008


predotdigits=zeros(size(poly))+1; 
nonzeros=find(poly~=0);
predotdigits(nonzeros)=floor(log10(abs(poly(nonzeros)))+1); % digits left o decimal dot
factor=10.^(digits-predotdigits);
roundpoly=round(poly.*factor)./factor;

               
return;
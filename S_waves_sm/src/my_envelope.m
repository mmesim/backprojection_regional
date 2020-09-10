function   fenv=my_envelope(y)
%function to calculate normalized envelopes 
%for each station
%--------------------------------------------------------------------------

for i=1:length(y)
temp=y{1,i};    
trans=hilbert(temp); 
env=abs(trans);
fenv{1,i}=env./max(env);
end

end

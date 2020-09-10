function [yN_proc,yE_proc]=my_preprocessing(yN,yE,delta,type,co)
%Preprocessing
%(1) remove mean
%(2) remove trend
%(3) filter
%--------------------------------------------------------------------------
%Preallocate memory
yN_proc=cell(1,length(yN));
yE_proc=cell(1,length(yE));

parfor i=1:length(yN)
tempN=yN{1,i};
tempE=yE{1,i};
%01. remove mean
ymN=tempN-mean(tempN);
ymE=tempE-mean(tempE);
%02. remove trend
yrN=my_detrend(ymN,1);
yrE=my_detrend(ymE,1);
%03. filter
yfN=my_filter(yrN,type,delta,co);
yfE=my_filter(yrE,type,delta,co);
yN_proc{1,i}=yfN;
yE_proc{1,i}=yfE;
end

end
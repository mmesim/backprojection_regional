function [y_proc]=my_preprocessing(y,delta,type,lcorner,hcorner)

%Preallocate memory
y_proc=cell(1,length(y));

parfor i=1:length(y) %change it to parfor
temp=y{1,i};
%01. remove mean
ym=temp-mean(temp);
%02. remove trend
yr=my_detrend(ym,1);
%03. filter
yf=my_filter(yr,type,delta,lcorner,hcorner);
y_proc{1,i}=yf;
end

end
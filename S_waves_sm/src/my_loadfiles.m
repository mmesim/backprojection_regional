function   [yN,yE,headerN,headerE]=my_loadfiles(mydata)
%list all sac files in directory
%and loop through them to read sac files

data_path1=sprintf('%s/*ENN.sac',mydata); %N-S
data_path2=sprintf('%s/*ENE.sac',mydata); %E-W

listing1=dir(data_path1);
listing2=dir(data_path2);
%Preallocate memory
yN=cell(1,length(listing1));
yE=cell(1,length(listing2));
%--------------------------------------------------
parfor i=1:length(listing1)
%N-S component    
filename1=sprintf('%s/%s',mydata,listing1(i).name);
[D1,~,H1]=rdsac(filename1);
%- E-W component
filename2=sprintf('%s/%s',mydata,listing2(i).name);
[D2,~,H2]=rdsac(filename2);
%------- add waveforms to a signle cell -----------
yN{1,i}=D1;
yE{1,i}=D2;
%------- add headers to a signle structure --------
headerN(i)=H1;
headerE(i)=H2;
end
%--------------------------------------------------
end
function beam=my_stacking(waveform,N,order)
%03. Stacking using Nth root stacking
% Return beam

for i=1:N
%keep sign
sg=sign(waveform(i,:));
%absolute amplitudes and normalize trace
wabs=abs(waveform(i,:));
%Calculate Nth root beam for each station
indiv_beam(i,:)=sg.*wabs.^(1/order);    
end

%Sum and normalize by number of stations
one_beam=sum(indiv_beam)./N;

% Nth root beam
sgb=sign(one_beam);
beam=sgb.*one_beam.^order;

end
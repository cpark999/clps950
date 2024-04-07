start = 102361;
duration = 313;
figure; 
for ch = 1:25
    righthandplot1 = ALLEEG.data(ch, start:start+duration); 
    plot(righthandplot1); 
    hold on; 
end

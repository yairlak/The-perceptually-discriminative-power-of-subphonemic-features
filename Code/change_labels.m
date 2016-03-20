function labels = change_labels(labels)
% settings.featureNames_ARTICULATORY_ORTHO =
%{'Labial'; 'Dental'; 'Alveolar'; 'Post alveolar'; 'Palatal'; 'Velar'; 'Glottal'; 'Plosive'; 'Affricate'; 'Fricative'; 'Nasal'; 'Lateral'; 'Rhotic'; 'Glide'; 'Voiced'};
% settings.featureNames_HALLE_CLEMENTS = 
%{'Consonantal', 'Sonorant', 'Continuant', 'Delayed release', 'Strident', 'Voiced', 'Nasal', 'Dorsal', 'Anterior', 'Labial', 'Coronal', 'Distributed', 'Lateral'};

for i = 1:length(labels)
   switch labels{i}
       case 'Labial' 
           labels{i} = 'Lbl';
       case 'Dental' 
           labels{i} = 'Dnt';
       case 'Alveolar'
           labels{i} = 'Alv';
       case 'Post alveolar'
           labels{i} = 'PsA';
       case 'Palatal' 
           labels{i} = 'Plt';
       case 'Velar' 
           labels{i} = 'Vlr';
       case 'Glottal' 
           labels{i} = 'Glt';
       case 'Plosive'
           labels{i} = 'Pls';
       case 'Affricate' 
           labels{i} = 'Aff';
       case 'Fricative' 
           labels{i} = 'Frc';
       case 'Nasal' 
           labels{i} = 'Nsl';
       case 'Lateral'
           labels{i} = 'Ltr';
       case 'Rhotic'
           labels{i} = 'Rtc';
       case 'Glide'
           labels{i} = 'Gld';
       case 'Voiced'
           labels{i} = 'Vcd';
       case 'Consonantal'
           labels{i} = 'Cns';
       case 'Continuant'
           labels{i} = 'Cnt';
       case 'Strident'
           labels{i} = 'Str';
       case 'Dorsal'
           labels{i} = 'Drs';
       case 'Anterior'
           labels{i} = 'Ant';
       case 'Coronal'
           labels{i} = 'Crn';
    
end



end
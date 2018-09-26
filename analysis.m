clear all;
% set the data in plot to change the type : 
%original_typen original_types original_typev original_typef original_typeq
%PATH= 'C:\Windows\System32\1D_deeplearntoolbox\ECG_data\'; % path
for n=100:100
%100 101 103 105 106 108 109 111-119 121-124 are records selected at random
%200-203 205 207-210 212-215 219-223 228 230-234 are records selected to
%include less common but clinically important arrhythmias
%102 104 107 217 are paced records that should be excluded
  if (n~=102) && (n~=104) && (n~=107) && (n~=217) && (n~=114)...
          && (n~=110) && (n~=120) && ((n<125)||(n>199))&&(n~=204)...
           && (n~=206) && (n~=211) && (n~=216) && (n~=224)&&(n~=225)...
           &&(n~=226)&&(n~=227)&&(n~=229)&& (n~=218)
       file_name=['individual_data_900\',num2str(n),'.mat'];
       load(file_name);
      %{
       if ~isempty(original_typen) %change type here
           figure;
           plot(original_typen(1:301,1:end)); %change type here
           title_name=['record ',num2str(n), ' Type N'];
           title(title_name);
       end
       if ~isempty(original_types)
           figure;
           plot(original_types(1:301,1:end)); 
           title_name=['record ',num2str(n) ' Type S'];
           title(title_name);
       end
       if ~isempty(original_typev)  
           figure;
           plot(original_typev(1:301,1:end));  
           title_name=['record ',num2str(n) ' Type V'];
           title(title_name);
       end
       %}
       if ~isempty(original_typev) %change type here
           figure;
           plot(original_typev(1:301,1:end)); %change type here
           title_name=['record ',num2str(n) ' Type V'];
           title(title_name);
       end
  end
end
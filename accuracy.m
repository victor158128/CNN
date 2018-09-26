function [accuracy_avg, sensitivity_avg, predictivity_avg, f_p_avg, fusionmatrix]=accuracy(data,biases,weights,num_layers,input_num,n_point,activition_function)

   c1=0;c2=0;c3=0;c4=0;c5=0;n12=0;n13=0;n14=0;n15=0;n21=0;n23=0;n24=0;n25=0;n31=0;n32=0;n34=0;n35=0;
    n42=0;n43=0;n41=0;n45=0;n52=0;n53=0;n54=0;n51=0;
    for i=1:length(data(1,:))
     out_net=feedforward_eval(biases,weights,num_layers,data(1:input_num,i),n_point,activition_function);
     sample_out=data(input_num+1:end,i);
     xx=find(out_net==max(out_net));
     x=xx(1);
     y=find(sample_out==max(sample_out));
     if x==y
         switch x
             case 1
                 c1=c1+1;
             case 2
                 c2=c2+1;
             case 3
                 c3=c3+1;
             case 4
                 c4=c4+1;
             case 5
                 c5=c5+1;
         end
     elseif x~=y
         switch x
             case 1
                 switch y
                     case 2
                         n12=n12+1;
                     case 3
                         n13=n13+1;
                     case 4
                         n14=n14+1;
                     case 5
                         n15=n15+1;
                 end
             case 2
                 switch y
                     case 1
                         n21=n21+1;
                     case 3
                         n23=n23+1;
                     case 4
                         n24=n24+1;
                     case 5
                         n25=n25+1;
                 end
             case 3
                 switch y
                     case 1
                         n31=n31+1;
                     case 2
                         n32=n32+1;
                     case 4
                         n34=n34+1;
                     case 5
                         n35=n35+1;
                 end
             case 4
                 switch y
                     case 1
                         n41=n41+1;
                     case 2
                         n42=n42+1;
                     case 3
                         n43=n43+1;
                     case 5
                         n45=n45+1;
                 end
             case 5
                 switch y
                     case 1
                         n51=n51+1;
                     case 2
                         n52=n52+1;
                     case 3
                         n53=n53+1;
                     case 4
                         n54=n54+1;
                 end
         end
     end
    end    

fusionmatrix=[c1 n12 n13 n14 n15;n21 c2 n23 n24 n25;n31 ...
    n32 c3 n34 n35;n41 n42 n43 c4 n45;n51 n52 n53 n54 c5];


accuracy_n = (c1+ c2+n23+n24+n32+c3+n34+n42+n43+c4)/length(data(1,:));
accuracy_s = (c2+ c1+n13+n14+n31+c3+n34+n41+n43+c4)/length(data(1,:));
accuracy_v = (c3+ c1+n12+n14+n21+c2+n24+n41+n42+c4)/length(data(1,:));
accuracy_f = (c4+ c1+n12+n13+n21+c2+n23+n31+n32+c3)/length(data(1,:));
accuracy_avg = (accuracy_n+accuracy_s+accuracy_v+accuracy_f)/4;
%accuracy = [accuracy_n accuracy_s accuracy_v accuracy_f accuracy_avg];


sensitivity_n = c1/(c1+n12+13+n14);
sensitivity_s = c2/(c2+n21+n23+n24);
sensitivity_v = c3/(c3+n31+n32+n34);
sensitivity_f = c4/(c4+n41+n42+n43);
%sensitivity = [sensitivity_n sensitivity_s sensitivity_v sensitivity_f sensitivity_avg];
if isnan(sensitivity_n) || isnan(sensitivity_s) || isnan(sensitivity_v) || isnan(sensitivity_f)
    sensitivity_avg = -1;
else 
    sensitivity_avg = (sensitivity_n+sensitivity_s+sensitivity_v+sensitivity_f)/4;
end

predictivity_n = c1/(c1+n21+n31+n41);
predictivity_s = c2/(c2+n12+n32+n42);
predictivity_v = c3/(c3+n13+n23+n43);
predictivity_f = c4/(c4+n14+n24+n34);
%predictivity = [predictivity_n predictivity_s predictivity_v predictivity_f predictivity_avg];
if isnan(predictivity_n) || isnan(predictivity_s) || isnan(predictivity_v) || isnan(predictivity_f)
    predictivity_avg = -1;
else 
    predictivity_avg = (predictivity_n+predictivity_s+predictivity_v+predictivity_f)/4;
end


f_p_n = (n21+n31+n41)/(c2+n23+n24+n32+c3+n34+n42+n43+c4 +n21+n31+n41);
f_p_s = (n12+n32+n42)/(c1+n13+n14+n31+c3+n34+n41+n43+c4 +n12+n32+n42);
f_p_v = (n13+n23+n43)/(c1+n12+n14+n21+c2+n24+n41+n42+c4 +n13+n23+n43);
f_p_f = (n14+n24+n34)/(c1+n12+n13+n21+c2+n23+n31+n32+c3 +n14+n24+n34);
f_p_avg = (f_p_n+f_p_s+f_p_v+f_p_f)/4;
%f_p = [f_p_n f_p_s f_p_v f_p_f f_p_avg];
end
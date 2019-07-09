function importingData(switch_name)
    %This function imports data for interpolation.
    %Linear method is used for interpolation.
    %To show the reliability of interpolation, remove all percentage signs (%) in the front of the annotated code.

    %Configuring settings to save figures automatically without displaying
%     set(0,'DefaultFigureVisible','off');
    
	%Defining global variables
    global data_Es_on_25;
    global data_Es_off_25;
    global data_Vds_18;
    global data_Vsd_18;
    
    %Generating free variables for examples of interpoaltion
%     Imax=600;%A
%     I_step=0.1;%A
%     m=ceil(Imax/I_step)+1;
%     I_interp=linspace(0,Imax,m);
    
    %Interpolating Es_on_25
    name_Es_on_25="DATA/EON"+switch_name+".txt";
    data_Es_on_25=importdata(name_Es_on_25);%First column, I, A; Second column, E, mJ
    %Getting and plotting an example of interpolation
%     Es_on_25=interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_interp,'linear','extrap');
%     dlmwrite("Interpolation/EON"+switch_name+".txt",1e3*Es_on_25');
%     figure();
%     plot(data_Es_on_25(:,1),data_Es_on_25(:,2),'or',I_interp,Es_on_25*1e3,'-b');
%     grid on;
%     grid minor;
%     title("EON"+switch_name+"(Istep="+num2str(I_step)+"A)");
%     xlabel("I (A)");
%     ylabel("E (mJ)");
%     saveas(gcf,"Interpolation/EON"+switch_name+".jpg");
    
    %Interpolating Es_off_25
    name_Es_off_25="DATA/EOFF"+switch_name+".txt";
    data_Es_off_25=importdata(name_Es_off_25);%First column, I, A; Second column, E, mJ
    %Getting and plotting an example of interpolation
%     Es_off_25=interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_interp,'linear','extrap');
%     dlmwrite("Interpolation/EOFF"+switch_name+".txt",1e3*Es_off_25');
%     figure();
%     plot(data_Es_off_25(:,1),data_Es_off_25(:,2),'or',I_interp,Es_off_25*1e3,'-b');
%     grid on;
%     grid minor;
%     title("EOFF"+switch_name+"(Istep="+num2str(I_step)+"A)");
%     xlabel("I (A)");
%     ylabel("E (mJ)");
%     saveas(gcf,"Interpolation/EOFF"+switch_name+".jpg");
    
    %Interpolating Vds_18
    name_Vds_18="DATA/VDS"+switch_name+".txt";
    data_Vds_18=importdata(name_Vds_18);%First column, I, A; Second column, V, V
    %Getting and plotting an example of interpolation
%     Vds_18=interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_interp,'linear','extrap');
%     dlmwrite("Interpolation/VDS"+switch_name+".txt",Vds_18');
%     figure();
%     plot(data_Vds_18(:,1),data_Vds_18(:,2),'or',I_interp,Vds_18,'-b');
%     grid on;
%     grid minor;
%     title("VDS"+switch_name+"(Istep="+num2str(I_step)+"A)");
%     xlabel("I (A)");
%     ylabel("V (V)");
%     saveas(gcf,"Interpolation/VDS"+switch_name+".jpg");
    
    %Interpolating Vsd_18
    name_Vsd_18="DATA/VSD"+switch_name+".txt";
    data_Vsd_18=importdata(name_Vsd_18);%First column, I, A; Second column, V, V
    %Getting and plotting an example of interpolation
%     Vsd_18=interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_interp,'linear','extrap');
%     dlmwrite("Interpolation/VSD"+switch_name+".txt",Vsd_18');
%     figure();
%     plot(data_Vsd_18(:,1),data_Vsd_18(:,2),'or',I_interp,Vsd_18,'-b');
%     grid on;
%     grid minor;
%     title("VSD"+switch_name+"(Istep="+num2str(I_step)+"A)");
%     xlabel("I (A)");
%     ylabel("V (V)");
%     saveas(gcf,"Interpolation/VSD"+switch_name+".jpg")
    
    %Configuring settings back to the default
%     set(0,'DefaultFigureVisible','on');
end
function interpolating(switch_name,I_step)
    %Generating the free variable of tables
    Imax=600;%A
    m=ceil(Imax/I_step)+1;
    I_interp=linspace(0,Imax,m);
    
    %Defining global variables
    global Es_on_25
    global Es_off_25
    global Vds_18
    global Vsd_18
    
    %Interpolating Es_on_25
    name_Es_on_25="DATA/EON"+switch_name+".txt";
    data_Es_on_25=importdata(name_Es_on_25);%First column, I, A; Second column, E, mJ
    Es_on_25=interp1(data_Es_on_25(:,1),data_Es_on_25(:,2)/1e3,I_interp,'spline','extrap');
    
    %Interpolating Es_off_25
    name_Es_off_25="DATA/EOFF"+switch_name+".txt";
    data_Es_off_25=importdata(name_Es_off_25);%First column, I, A; Second column, E, mJ
    Es_off_25=interp1(data_Es_off_25(:,1),data_Es_off_25(:,2)/1e3,I_interp,'spline','extrap');
    
    %Interpolating Vds_18
    name_Vds_18="DATA/VDS"+switch_name+".txt";
    data_Vds_18=importdata(name_Vds_18);%First column, I, A; Second column, V, V
    Vds_18=interp1(data_Vds_18(:,1),data_Vds_18(:,2),I_interp,'spline','extrap');
    
    %Interpolating Vsd_18
    name_Vsd_18="DATA/VSD"+switch_name+".txt";
    data_Vsd_18=importdata(name_Vsd_18);%First column, I, A; Second column, V, V
    Vsd_18=interp1(data_Vsd_18(:,1),data_Vsd_18(:,2),I_interp,'spline','extrap');
end
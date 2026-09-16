function [Z,Ei,MidPoints] = generateZ(P,edges)

        % This function generates the impedance matrix for a 2D MoM
        % problem: An incident field E0 with TMz polarization with a PEC
        % infinitely long cylinder


       %Physical Constants=================================================
        E0 = 1; %Incident E field amplitude
        wavelength = 1; %wavelength
        k =2*pi/wavelength; %wave number
        angi = 0*pi/180; %incident angle
        u0 = (4*pi)*1e-7; %vacum permeability
        e0 = 8.854e-12; %vacuum permittivity 
        nn = sqrt(u0/e0); %eta = wave impedance
        gamman = 1.781072418; %constant in matrix R definition
        w = k/sqrt(nn*e0); %wavelength of E
        maxitt = length(P(:,1));
        %Matrix Initialization 
        MidPoints = zeros(maxitt,2); %midpoints: points where E=Z*J is approx.
        P_diff = zeros(maxitt,2); 
        %Physical Constants
        u0 = (4*pi)*1e-7; %vacum permeability
        e0 = 8.854e-12; %vacuum permittivity 
        nn = sqrt(u0/e0); %eta = wave impedance
        gamman = 1.781072418; %constant in matrix R definition
        %calculate the midpoints in each segment
        MidPoints(edges(:,1),:) = (P(edges(:,1), :) + P(edges(:,2), :)) / 2; %midpoints of each seg
        P_diff(edges(:,1),:) =(P(edges(:,1), :)-P(edges(:,2), :));
        wn = sqrt(sum(P_diff.^2, 2));
        %create IMPEDANCE MATRIX-------------------------------------------
        no=numel(MidPoints)/2;
        ns=numel(MidPoints)/2;
        Z = zeros(no,ns);
        Wn = ones(no,ns).*wn';
        Ggrad{1}=MidPoints(:,1)*ones([1 ns])-...
        ones([no 1])*(MidPoints(:,1).');
        Ggrad{2}=MidPoints(:,2)*ones([1 ns])-...
        ones([no 1])*(MidPoints(:,2).');
        rhovals=sqrt(Ggrad{1}.^2+Ggrad{2}.^2);
        rhovals(1,end)=rhovals(1,end-1);
        rhovals(end,1)=rhovals(end-1,1);
        Z(rhovals~=0)=k*nn/4*besselh(0,2,k*rhovals(rhovals~=0));
        Z(rhovals==0)=(k*nn/4)*(1-(2*1i/pi)*(log(gamman*k*wn/4)-1));
        Z = Wn.*Z;
        %define incident electric field 
        Ei = E0*exp(-1i*k*(MidPoints(:,1)*cos(angi) + MidPoints(:,2)*sin(angi)));
        % %solve for J------------------
        % J = Z\Ei;
        % J_real = J;
        % %
        % theta = linspace(2*pi/N,2*pi,N);
        % %its necessary to re-calculate MidPoints-----------------------------------
        % MidPoints = zeros(N,2); %midpoints: points where E=Z*J is approx.
        % MidPoints(edges(:,1),:) = (P(edges(:,1), :) + P(edges(:,2), :)) / 2; %midpoints of each seg
        % P_diff =(P(edges(:,1), :)-P(edges(:,2), :));
        % wn = sqrt(sum(P_diff.^2, 2));
        % %--------------------------------------------------------------------------
        % %rcs_real
        % rcs_real = (k*nn^2/4)*abs( sum( J_real.*wn.*exp(1i*k*(MidPoints(:,1).*cos(theta) + MidPoints(:,2).*sin(theta))) )).^2;
        % rcs_real = rcs_real';
    end 
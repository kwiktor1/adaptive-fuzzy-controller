function [optsect,optevals] = ...
    evaluations(sectors,p,B,H,d1,d2,puls,beta1,beta2,k1,k2)

x01 = [-1, 0, 1]';
x02 = [-1, 0, 1]';
x03 = [-1, 0, 1]';

% calculate estimates for each sector
for i = 1:size(sectors,1),i
    
    beta1 = sectors(i,1);
    k1 = sectors(i,2) - sectors(i,1);
    beta2 = sectors(i,3);
    k2 = sectors(i,4) - sectors(i,3);
    
    % calculate estimates for all 
    % combination of initial conditions except [0,0,0]'
    evtmpl = [];
    evtmpn = [];
    for a = 1:length(x01)
        for b = 1:length(x02)
            for c = 1:length(x03)
                x0 = [x01(a),x02(b),x03(c)]';
                if any(x0 ~= [0,0,0]')
                    % calculate estimates for all A
                    for k = 1:length(p)
                        A = [-4,p(k),-10;
                              1,0,0;
                              0,1,0];
                        [Ixl,Iul,Ixn,Iun] = ...
                            evals(A,B,H,d1,d2,x0,puls,beta1,beta2,k1,k2);
                        evtmpl = [evtmpl; Ixl,Iul];
                        evtmpn = [evtmpn; Ixn,Iun];
                    end
                end
           end
        end
    end
    
    % average of estimates
    evl(i,:) = mean(evtmpl);
    evn(i,:) = mean(evtmpn);
end

% ===================================================
% Note: take only the widest sectors

figure(4)

% sector width?
w1 = sectors(:,2)-sectors(:,1);
w2 = sectors(:,4)-sectors(:,3);

% width product
w = w1.*w2;

% indexes of the broadest sectors
is = find((w >= max(w)-eps) & (w <= max(w)+eps));

plot(evn(:,1),evn(:,2),'*',evn(is,1),evn(is,2),'o')
legend({'all sectors','the widest sectors'})

% distance to the origin of the coordinate system
dist = sqrt(evn(is,1).^2 + evn(is,2).^2);

% smallest distance
[~,ix] = min(dist);

% solution
optsect = sectors(is(ix),:);
optevals = evn(is(ix),:);

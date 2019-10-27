%-----------------------------------------------------------
% Use matlab with multi core
%-----------------------------------------------------------

function processdata_mc(data,label,folder)

 c = parcluster('local'); % build the 'local' cluster object
 nw = c.NumWorkers;        % get the number of workers
 l=fix((length(label))/nw);

spmd (nw)
        processdata(data,l*(labindex-1)+1,l*labindex,label,folder)
end

i=length(label)-l*nw;
processdata(data,l*nw,l*nw+i,label,folder)
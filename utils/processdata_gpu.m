function processdata_gpu(data,label,folder)


 c = parcluster('local'); % build the 'local' cluster object
    nw = c.NumWorkers;        % get the number of workers
 l=fix((length(label))/nw);
s=0;

spmd (nw)
        processdata(data,l*(labindex-1)+1,l*labindex,label,folder)
end

i=length(label)-l*nw;
processdata(data,l*nw,l*nw+i,label,folder)
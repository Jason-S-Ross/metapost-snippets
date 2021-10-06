def drawspring(expr p, ncoils) =
    begingroup; save sublength, pathangle;
        numeric sublength;
        numeric pathangle;

        sublength := arclength(p) / (ncoils + 1);
        pathangle := angle(point 1 of p - point 0 of p);

        draw point 0 of p
        -- (point 0 of p + dir(pathangle) * sublength / 2)
        for i=2 step 4 until 4 * ncoils :
            --(point (i + 1) / (4 * ncoils + 4) of p)
                shifted (dir (pathangle + 90) * (sublength / 2))
            --(point (i + 3) / (4 * ncoils + 4) of p)
                shifted (dir (pathangle - 90) * (sublength / 2))
            --(point ((i + 4) / (4 * ncoils + 4)) of p)
        endfor
        -- (point 1 of p - dir(pathangle) * sublength / 2)
        -- (point 1 of p);
    endgroup;
enddef;

def drawrigid(expr p, nhatches, hatchwidth) =
    begingroup;
        save pathangle;
        numeric pathangle;
        pathangle := angle(point 1 of p - point 0 of p);
        for i=0 step 1 until nhatches :
            draw point (i / nhatches) of p
            -- point (i / nhatches) of p shifted (hatchwidth * dir(pathangle + 45));
        endfor;
    endgroup;
enddef;

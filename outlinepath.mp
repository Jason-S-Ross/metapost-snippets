def get_outlined_path(expr p, d) =
  begingroup;
    path penpath[];
    pen mypen;
    numeric L;
    L := 10;
    penpath[-1] := (((1, 0)) for i=1 upto L-1:
        -- (cosd(i/L*360),sind(i/L*360))
    endfor --cycle );
    mypen := makepen(penpath[-1]) scaled (d/2);
    envelope mypen of p
  endgroup;
enddef;

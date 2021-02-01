leaderextension:=0.25cm;
leadergap := 0.15cm;
def _draw_dim(expr A, B, extang, leadang, obliqueang, textang, offset, Text) =
  % Generic function to draw extension lines
  begingroup; save C, D, E, F, G, H, CA, cpen, lab, arr;
    pair C, D, E, F, G, H;
    pair CA;
    pen cpen;
    cpen := currentpen;
    pickup defaultpen;
    C := A + offset * dir(extang);
    CA := dir(angle(C-A));
    % Project B-A in the direction of leadang
    D := C + (
        ((xpart (B-A)) * (xpart (dir(leadang))))
        + ((ypart (B-A)) * (ypart (dir(leadang)))))
      * dir(leadang);
    % Use C-A as the angle because it's set by offset which is non-zero hopefully
    E := C +  leaderextension * CA;
    F := D +  leaderextension * CA;
    G := A + leadergap * CA;
    H := B + leadergap * CA;
    picture lab;
    picture arr;
    arr := image(drawdblarrow (0,0)--(abs(D-C),0););
    draw ((arr slanted (sind(obliqueang)/cosd(obliqueang))) rotated angle(D-C)) shifted C;
    lab:=(thelabel(Text, (0,0)) slanted (sind(obliqueang)/cosd(obliqueang))) rotated textang shifted 0.5[C,D];
    draw G--E;
    draw H--F;
    unfill bbox lab; draw lab;
    pickup cpen;
  endgroup;
enddef;
def draw_aligned_dim(expr A, B, Text, offset) =
  _draw_dim(A, B, (angle(A-B) + 90), (angle(A-B)), 0, 0, offset, Text);
enddef;
def draw_vertical_dim(expr A, B, Text, offset) =
  _draw_dim(A, B, (0), -90, 0, 0, offset, Text);
enddef;
def draw_horizontal_dim(expr A, B, Text, offset) =
  _draw_dim(A, B, (90), 0, 0, 0, offset, Text);
enddef;
def draw_oblique_dim(expr A, B, Text, offset, measang, extang, alt) =
  if alt:
    _draw_dim(A, B, extang, measang, extang, measang, offset, Text);
  else:
    _draw_dim(A, B, extang, measang, -extang, measang, offset, Text);
  fi;
enddef;
def draw_angle_dim(expr A, B, C, Text, offset) =
  begingroup; save cpen, D, E, F, G, H, I, J, ang, p, lab;
    cpen := currentpen;
    pickup defaultpen;
    pair D, E, F, G, H, I, J;
    numeric ang[];
    ang1 := angle(A-C);
    ang2 := angle(B-C);
    ang3 := (ang1 + ang2) / 2.0;
    D := A + offset * dir(ang1);
    E := C + (abs (D - C)) * dir(ang2);
    ang4 := angle(D-A);
    ang5 := angle(E-B);
    F := D + leaderextension * dir(ang4);
    G := E + leaderextension * dir(ang5);
    H := A + leadergap * dir(ang4);
    I := B + leadergap * dir(ang5);
    J := C + (abs(D - C) * dir(ang3));
    draw H--F;
    draw I--G;
    path p;
    p := D{dir(ang1 + 270)} .. J{dir(ang3 + 270)} .. E{dir(ang2 + 270)};
    drawdblarrow p;
    picture lab;
    lab := thelabel(Text, J);
    unfill bbox lab; draw lab;
    pickup cpen;
  endgroup;
enddef;
def draw_radial_dim(expr C, r, ang, Text, offset) =
  begingroup; save A, B, D, lab;
    pair A, B, D;
    A := C + dir(ang) * r;
    B := C + dir(ang) * (r + offset);
    drawarrow (if offset > 0 : B else: C fi) --A;
    picture lab;
    lab := thelabel(Text, B);
    unfill bbox lab; draw lab;
  endgroup;
enddef;

%% Usage:

% beginfig(0)
%   begingroup;
%     pair v[];
%     v[0] := (0,0);
%     v[1] := (2cm, 0);
%     v[1] := v[1] rotated 30;
%     v[2] := v[1] rotated 120 shifted v[1];
%     v[3] := v[1] rotated 120;
%     v[4] := v[1] rotated 240;
%     v[5] := v[1] shifted v[4];
%     v[6] := v[3] shifted v[4];
%     draw v[0]--v[1]--v[2]--v[3]--cycle;
%     draw v[0]--v[4]--v[5]--v[1];
%     draw v[4]--v[6]--v[3];
%     draw_oblique_dim(v[5], v[1], btex vert etex, 2cm, 90, 30, true);
%     draw_oblique_dim(v[5], v[1], btex vert etex, 2cm, 90, -30, true);
%     draw_oblique_dim(v[4], v[5], btex flat etex, 2cm, 30, -30, true);
%     draw_oblique_dim(v[6], v[4], btex flat etex, -2cm, -30, 30, true);
%     draw_oblique_dim(v[4], v[0], btex vert etex, 2cm, 90, -30, false);
%     draw_oblique_dim(v[3], v[0], btex vert etex, -2cm, -30, 30, false);
%   endgroup;
% endfig;
%
% beginfig(1)
%   begingroup;
%     numeric u;
%     u := 2in;
%     pair P[];
%     P0 = (0,0);
%     P1 = (1u, 0);
%     P2 = (0.4u, 0.7u);
%     draw P0--P1--P2--cycle;
%     draw_aligned_dim(P0, P1, btex $a$ etex, .2u);
%     draw_aligned_dim(P1, P2, btex $b$ etex, .2u);
%     draw_aligned_dim(P2, P0, btex $c$ etex, .2u);
%     draw_angle_dim(P0, P2, P1, btex $\theta$ etex, -.5u);
%     label(btex $c^2 = a^2 + b^2 - 2 a b \cos{\theta}$ etex, (0.5u, -.4u));
%   endgroup  ;
% endfig;
%
% beginfig(2)
%   begingroup;
%     path c;
%     numeric radius;
%     radius := 0.75in;
%     c := fullcircle scaled (2 * radius);
%     draw fullcircle scaled .1in;
%     draw c;
%     draw_radial_dim((0,0), radius, 120, btex $r$ etex, -0.25in);
%     pair P[];
%     P1 := (point 5 of c);
%     P2 := (point 8 of c);
%     dotlabel.lft(btex $A$ etex, P1);
%     dotlabel.rt(btex $B$ etex, P2);
%     path beam;
%     beam := P1--P2;
%     draw beam withpen pencircle scaled 1bp;
%     dotlabel.ulft(btex $dog$ etex, 0.3[P1,P2]);
%     draw_aligned_dim(P1, P2, btex $l$ etex, 0.75in);
%   endgroup;
% endfig;
% end;

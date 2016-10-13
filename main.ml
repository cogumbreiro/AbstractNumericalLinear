open Hilbertspace;;

module FloatComplex : ComplexNumber with type ret=float with type imt=float  = 
  struct
    type ret = float
    type imt = float
    type t   = { re : ret; im : imt;}

    let mk re im = {re=re;im=im;}

    let re c = c.re
    let im c = c.im

    let conj c = {re=c.re; im=(0.0 -. c.im);}

    let mul c1 c2 = 
      let a=c1.re in
      let b=c1.im in
      let c=c2.re in
      let d=c2.im in    
      {re=a*.c-.b*.d;im=a*.d+.b*.c}
    let add c1 c2 = {re=c1.re +. c2.re;im=c1.im +. c2.im}

    let inv c = 
      let a=c.re in
      let b=c.im in
      {re=a/.(a*.a+.b*.b);im=0.0 -. b /. (a*.a +. b*.b)}

    let zero   = {re=0.0;im=0.0}
    let one    = {re=1.0;im=0.0}

    let show z = (string_of_float (re z)) ^ " + " ^ (string_of_float (im z)) ^ "i"



  end
;;

module ArrayHilbert : HilbertSpace with type vect=FloatComplex.t array with type ct = FloatComplex.t = struct
  let m=10

  type vect = FloatComplex.t array
  type ct   = FloatComplex.t
  let nullvector = Array.make m (FloatComplex.mk 0.0 0.0)
  let basis      = 
    let nv = Array.make m (FloatComplex.mk 0.0 0.0) in
    [nv;nv]
  let scalarmul  x y = 
    let mulx z = FloatComplex.mul x z in
    Array.map mulx y
  ;;
  let add x y = Array.map2 (FloatComplex.add) x y

  let innerprod  x y = 
    let xy = Array.map2 (FloatComplex.mul) x y in
    Array.fold_left (FloatComplex.add) (FloatComplex.zero) xy
  ;;


end;;


(*module MyOrth : Orthogonalizable = MakeOrthogonalizable (FloatComplex : ComplexNumber with type t=FloatComplex.t) (ArrayHilbert : HilbertSpace with type vect=ArrayHilbert.vect);;*)

module MyOrth = MakeOrthogonalizable (FloatComplex) (ArrayHilbert)




let x = Array.make 10 (FloatComplex.mk 0.0 1.0)
let y = Array.make 10 (FloatComplex.mk 0.0 1.0)

let () = 
  let z=MyOrth.inprd2sum x y in
  print_endline (FloatComplex.show z)


From Coq Require Import ssreflect ssrfun ZArith.
From HB Require Import structures.

Module Enclosing.
(**************************************************************************)
(* Stage 0: +Ring+                                                        *)
(**************************************************************************)

HB.mixin Record Ring_of_TYPE A := {
  zero : A;
  one : A;
  add : A -> A -> A;
  opp : A -> A;
  mul : A -> A -> A;
  addrA : associative add;
  addrC : commutative add;
  add0r : left_id zero add;
  addNr : left_inverse zero opp add;
  mulrA : associative mul;
  mul1r : left_id one mul;
  mulr1 : right_id one mul;
  mulrDl : left_distributive mul add;
  mulrDr : right_distributive mul add;
}.
HB.structure Definition Ring := { A of Ring_of_TYPE A }.

(* Notations *)

Module RingExports.
Declare Scope hb_scope.
Delimit Scope hb_scope with G.
Local Open Scope hb_scope.
Notation "0" := zero : hb_scope.
Notation "1" := one : hb_scope.
Infix "+" := (@add _) : hb_scope.
Notation "- x" := (@opp _ x) : hb_scope.
Infix "*" := (@mul _) : hb_scope.
Notation "x - y" := (x + - y) : hb_scope.
End RingExports.
HB.export RingExports.

(* Theory *)

Section Theory.
Local Open Scope hb_scope.
Variable R : Ring.type.
Implicit Type (x : R).

Lemma addr0 : right_id (@zero R) add.
Proof. by move=> x; rewrite addrC add0r. Qed.

Lemma addrN : right_inverse (@zero R) opp add.
Proof. by move=> x; rewrite addrC addNr. Qed.

Lemma subrr x : x - x = 0.
Proof. by rewrite addrN. Qed.

Lemma addrNK x y : x + y - y = x.
Proof. by rewrite -addrA subrr addr0. Qed.

#[export]
HB.instance
Definition Z_ring_axioms :=
  Ring_of_TYPE.Build Z 0%Z 1%Z Z.add Z.opp Z.mul
    Z.add_assoc Z.add_comm Z.add_0_l Z.add_opp_diag_l
    Z.mul_assoc Z.mul_1_l Z.mul_1_r
    Z.mul_add_distr_r Z.mul_add_distr_l.

End Theory.

Module Exports.
HB.reexport.
Definition addrNK := addrNK.
Definition addr0 := addr0.
End Exports.
End Enclosing.

(* We miss the coercions, canonical and elpi metadata *)
Fail Check forall (R : Enclosing.Ring.type) (x : R), x = x.
Fail Check 0%G.

Export Enclosing.Exports.

Check forall (R : Enclosing.Ring.type) (x : R), x = x.
Check 0%G.
Example test1 (m n : Z) : ((m + n) - n + 0 = m)%G.
Proof. by rewrite addrNK addr0. Qed.

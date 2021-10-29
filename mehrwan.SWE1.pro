%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ECE3520/CpSc3520 SDE1: Prolog Declarative and Logic Programming

% Use the following Prolog relations as a database of familial
% relationships for 4 generations of people.  If you find obvious
% minor errors (typos) you may correct them.  You may add additional
% data if you like but you do not have to.

% Then write Prolog rules to encode the relations listed at the bottom.
% You may create additional predicates as needed to accomplish this,
% including relations for debugging or extra relations as you desire.
% All should be included when you turn this in.  Your rules must be able
% to work on any data and across as many generations as the data specifies.
% They may not be specific to this data.

% Using SWI-Prolog, run your code, demonstrating that it works in all modes.
% Log this session and turn it in with your code in this (modified) file.
% You examples should demonstrate working across 4 generations where
% applicable.

% Fact recording Predicates:

% list of two parents, father first, then list of all children
%  parent_list(?Parent_list, ?Child_list).

% Data:

parent_list([fred_smith, mary_jones],
            [tom_smith, lisa_smith, jane_smith, john_smith]).

parent_list([tom_smith, evelyn_harris],
            [mark_smith, freddy_smith, joe_smith, francis_smith]).

parent_list([mark_smith, pam_wilson],
            [martha_smith, frederick_smith]).

parent_list([freddy_smith, connie_warrick],
            [jill_smith, marcus_smith, tim_smith]).

parent_list([john_smith, layla_morris],
            [julie_smith, leslie_smith, heather_smith, zach_smith]).

parent_list([edward_thompson, susan_holt],
            [leonard_thompson, mary_thompson]).

parent_list([leonard_thompson, lisa_smith],
            [joe_thompson, catherine_thompson, john_thompson, carrie_thompson]).

parent_list([joe_thompson, lisa_houser],
            [lilly_thompson, richard_thompson, marcus_thompson]).

parent_list([john_thompson, mary_snyder],
            []).

parent_list([jeremiah_leech, sally_swithers],
            [arthur_leech]).

parent_list([arthur_leech, jane_smith],
            [timothy_leech, jack_leech, heather_leech]).

parent_list([robert_harris, julia_swift],
            [evelyn_harris, albert_harris]).

parent_list([albert_harris, margaret_little],
            [june_harris, jackie_harris, leonard_harris]).

parent_list([leonard_harris, constance_may],
            [jennifer_harris, karen_harris, kenneth_harris]).

parent_list([beau_morris, jennifer_willis],
            [layla_morris]).

parent_list([willard_louis, missy_deas],
            [jonathan_louis]).

parent_list([jonathan_louis, marsha_lang],
            [tom_louis]).

parent_list([tom_louis, catherine_thompson],
            [mary_louis, jane_louis, katie_louis]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


male(joe_smith).
male(francis_smith).
male(frederick_smith).
male(marcus_smith).
male(tim_smith).
male(zach_smith).
male(richard_thompson).
male(marcus_thompson).
male(timothy_leech).
male(jack_leech).
male(kenneth_harris).




female(jane_smith).
female(martha_smith).
female(jill_smith).
female(julie_smith).
female(leslie_smith).
female(heather_smith).
female(mary_thompson).
female(carrie_thompson).
female(lilly_thompson).
female(heather_leech).
female(june_harris).
female(jackie_harris).
female(jennifer_harris).
female(karen_harris).
female(mary_louis).
female(jane_louis).
female(katie_louis).












% SWE1 Assignment - Create rules for:

% returns true if X is the parent of Y

% parent(?Parent, ?Child).]

parent(X,Y) :-  parent_list(PL, CL), member(X,PL), member(Y,CL).


% returns true if X is married Y

% married(?Husband, ?Wife).

married(X,Y) :- parent_list(PL,_), member(X,PL), member(Y,PL), X\=Y.


% returns true if X is the ancestor of Y
% X can be Y's parent or a ancestor of Y's parent

% ancestor(?Ancestor, ?Person).

ancestor(X,Y) :- parent(X,Y) ; parent(P1,Y), ancestor(X, P1).


% returns true if X is the descendent of Y
% X can be Y's child or a descendent of Y's children

% descendent(?Descendent, ?Person).

descendent(X,Y) :- parent(Y,X) ; parent(Y,C1), descendent(X, C1).


% returns true if Z is the parent of X and Y or an ancestor of their parents

% common_ancestor(?Person1, ?Person2, ?Ancestor).

common_ancestor(X,Y,Z) :- parent(Z,X), parent(Z,Y);
                  parent(P1,X), parent(P2,Y), common_ancestor(P1,P2,Z), X\=Y.



% returns true if X is either a descendant of Y or vice-versa
% or X & Y have a common_ancestor

% blood(?Person1, ?Person2). %% blood relative

blood(X,Y) :- descendent(X,Y) ; descendent(Y,X)
                                    ; common_ancestor(X,Y,_), X\=Y.


% returns true if X is the brother or sister of Y

% sibling(?Person1, Person2).

sibling(X,Y) :- parent_list(_,CL), member(X,CL), member(Y,CL), X\=Y.



% returns true if X is the dad of Y

% father(?Father, ?Child).

father(X,Y) :- parent_list([X|_],CL), member(Y,CL).


% returns true if X is the mom of Y

% mother(?Mother, ?Child).

mother(X,Y) :- parent_list([_|[X|_]], CL), member(Y,CL).


% returns true if X is the uncle of Y

% uncle(?Uncle, ?Person). %%

uncle(X,Y) :- males(X), sibling(X,Z), parent(Z,Y), not(parent(X,Y))
                      ; male(X), sibling(X,Z), parent(Z,Y), not(parent(X,Y)).


% returns true if X is the aunt of Y

% aunt(?Aunt, ?Person). %%

aunt(X,Y) :- females(X), sibling(X,Z), parent(Z,Y), not(parent(X,Y))
                      ; female(X), sibling(X,Z), parent(Z,Y), not(parent(X,Y)).


% rules used to find the gender of X in uncle and aunt if they are married

males(X) :- parent_list([X|_],_).

females(X) :- parent_list([_|[X|_]],_).


% returns true if P1 and P2 are cousins

% cousin(?Cousin, ?Person).

cousin(P1,P2) :- lca(P1,P2,A), ancestor_count(A,P1,C1),
                                      ancestor_count(A,P2,C2), C1 > 1, C2 > 1.

% finds the distance between the ancestor and the person given

%ancestor_count(?ancestor, ?person, count)

ancestor_count(A,P,1) :- parent(A,P), !.

ancestor_count(A,P,N) :- parent(A,Z), ancestor_count(Z, P, C2), N is C2 + 1.


%finds the least common ancestor

% lca(?Person1, Person2, ?Ancestor).

lca(P1,P2,A) :- father(A,P1), father(A,P2), P1 \== P2.

lca(P1,P2,A) :- father(A,P1), father(A,P4), P1 \== P4, ancestor(P4, P2).

lca(P1,P2,A) :- father(A,P3), ancestor(P3,P1), father(A,P2), P3\== P2.

lca(P1,P2,A) :- father(A,P3), ancestor(P3, P1), father(A,P4), P3 \== P4,
                                                              ancestor(P4, P2).


% if person 1 and person 2 are provided, the cousin type and if they are once,
% twice, etc removed

%% 1st cousin, 2nd cousin, 3rd once removed, etc.
% cousin_type(+Person1, +Person2, -CousinType, -Removed).


cousin_type(P1,P2,T,R) :- lca(P1,P2,A), ancestor_count(A,P1,C1),
  ancestor_count(A,P2,C2), C1 > 1, C2 > 1, T is min(C1,C2) - 1, R is abs(C1-C2).

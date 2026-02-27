Preface.vo Preface.glob Preface.v.beautified Preface.required_vo: Preface.v /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Preface.vos Preface.vok Preface.required_vos: Preface.v /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Perm.vo Perm.glob Perm.v.beautified Perm.required_vo: Perm.v /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Perm.vos Perm.vok Perm.required_vos: Perm.v /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Sort.vo Sort.glob Sort.v.beautified Sort.required_vo: Sort.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Sort.vos Sort.vok Sort.required_vos: Sort.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Multiset.vo Multiset.glob Multiset.v.beautified Multiset.required_vo: Multiset.v Perm.vo Sort.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Multiset.vos Multiset.vok Multiset.required_vos: Multiset.v Perm.vos Sort.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
BagPerm.vo BagPerm.glob BagPerm.v.beautified BagPerm.required_vo: BagPerm.v Perm.vo Sort.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
BagPerm.vos BagPerm.vok BagPerm.required_vos: BagPerm.v Perm.vos Sort.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Selection.vo Selection.glob Selection.v.beautified Selection.required_vo: Selection.v Multiset.vo Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Selection.vos Selection.vok Selection.required_vos: Selection.v Multiset.vos Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Merge.vo Merge.glob Merge.v.beautified Merge.required_vo: Merge.v Perm.vo Sort.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Merge.vos Merge.vok Merge.required_vos: Merge.v Perm.vos Sort.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Maps.vo Maps.glob Maps.v.beautified Maps.required_vo: Maps.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Maps.vos Maps.vok Maps.required_vos: Maps.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SearchTree.vo SearchTree.glob SearchTree.v.beautified SearchTree.required_vo: SearchTree.v Maps.vo Perm.vo Sort.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SearchTree.vos SearchTree.vok SearchTree.required_vos: SearchTree.v Maps.vos Perm.vos Sort.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ADT.vo ADT.glob ADT.v.beautified ADT.required_vo: ADT.v Maps.vo Perm.vo SearchTree.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ADT.vos ADT.vok ADT.required_vos: ADT.v Maps.vos Perm.vos SearchTree.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Extract.vo Extract.glob Extract.v.beautified Extract.required_vo: Extract.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Extract.vos Extract.vok Extract.required_vos: Extract.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Redblack.vo Redblack.glob Redblack.v.beautified Redblack.required_vo: Redblack.v Extract.vo Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Redblack.vos Redblack.vok Redblack.required_vos: Redblack.v Extract.vos Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Trie.vo Trie.glob Trie.v.beautified Trie.required_vo: Trie.v Maps.vo Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Trie.vos Trie.vok Trie.required_vos: Trie.v Maps.vos Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Priqueue.vo Priqueue.glob Priqueue.v.beautified Priqueue.required_vo: Priqueue.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Priqueue.vos Priqueue.vok Priqueue.required_vos: Priqueue.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Binom.vo Binom.glob Binom.v.beautified Binom.required_vo: Binom.v Perm.vo Priqueue.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Binom.vos Binom.vok Binom.required_vos: Binom.v Perm.vos Priqueue.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Decide.vo Decide.glob Decide.v.beautified Decide.required_vo: Decide.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Decide.vos Decide.vok Decide.required_vos: Decide.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Color.vo Color.glob Color.v.beautified Color.required_vo: Color.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
Color.vos Color.vok Color.required_vos: Color.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
PrefaceTest.vo PrefaceTest.glob PrefaceTest.v.beautified PrefaceTest.required_vo: PrefaceTest.v Preface.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
PrefaceTest.vos PrefaceTest.vok PrefaceTest.required_vos: PrefaceTest.v Preface.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
PermTest.vo PermTest.glob PermTest.v.beautified PermTest.required_vo: PermTest.v Perm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
PermTest.vos PermTest.vok PermTest.required_vos: PermTest.v Perm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SortTest.vo SortTest.glob SortTest.v.beautified SortTest.required_vo: SortTest.v Sort.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SortTest.vos SortTest.vok SortTest.required_vos: SortTest.v Sort.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
MultisetTest.vo MultisetTest.glob MultisetTest.v.beautified MultisetTest.required_vo: MultisetTest.v Multiset.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
MultisetTest.vos MultisetTest.vok MultisetTest.required_vos: MultisetTest.v Multiset.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
BagPermTest.vo BagPermTest.glob BagPermTest.v.beautified BagPermTest.required_vo: BagPermTest.v BagPerm.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
BagPermTest.vos BagPermTest.vok BagPermTest.required_vos: BagPermTest.v BagPerm.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SelectionTest.vo SelectionTest.glob SelectionTest.v.beautified SelectionTest.required_vo: SelectionTest.v Selection.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SelectionTest.vos SelectionTest.vok SelectionTest.required_vos: SelectionTest.v Selection.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
MergeTest.vo MergeTest.glob MergeTest.v.beautified MergeTest.required_vo: MergeTest.v Merge.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
MergeTest.vos MergeTest.vok MergeTest.required_vos: MergeTest.v Merge.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
MapsTest.vo MapsTest.glob MapsTest.v.beautified MapsTest.required_vo: MapsTest.v Maps.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
MapsTest.vos MapsTest.vok MapsTest.required_vos: MapsTest.v Maps.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SearchTreeTest.vo SearchTreeTest.glob SearchTreeTest.v.beautified SearchTreeTest.required_vo: SearchTreeTest.v SearchTree.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
SearchTreeTest.vos SearchTreeTest.vok SearchTreeTest.required_vos: SearchTreeTest.v SearchTree.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ADTTest.vo ADTTest.glob ADTTest.v.beautified ADTTest.required_vo: ADTTest.v ADT.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ADTTest.vos ADTTest.vok ADTTest.required_vos: ADTTest.v ADT.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ExtractTest.vo ExtractTest.glob ExtractTest.v.beautified ExtractTest.required_vo: ExtractTest.v Extract.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ExtractTest.vos ExtractTest.vok ExtractTest.required_vos: ExtractTest.v Extract.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
RedblackTest.vo RedblackTest.glob RedblackTest.v.beautified RedblackTest.required_vo: RedblackTest.v Redblack.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
RedblackTest.vos RedblackTest.vok RedblackTest.required_vos: RedblackTest.v Redblack.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
TrieTest.vo TrieTest.glob TrieTest.v.beautified TrieTest.required_vo: TrieTest.v Trie.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
TrieTest.vos TrieTest.vok TrieTest.required_vos: TrieTest.v Trie.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
PriqueueTest.vo PriqueueTest.glob PriqueueTest.v.beautified PriqueueTest.required_vo: PriqueueTest.v Priqueue.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
PriqueueTest.vos PriqueueTest.vok PriqueueTest.required_vos: PriqueueTest.v Priqueue.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
BinomTest.vo BinomTest.glob BinomTest.v.beautified BinomTest.required_vo: BinomTest.v Binom.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
BinomTest.vos BinomTest.vok BinomTest.required_vos: BinomTest.v Binom.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
DecideTest.vo DecideTest.glob DecideTest.v.beautified DecideTest.required_vo: DecideTest.v Decide.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
DecideTest.vos DecideTest.vok DecideTest.required_vos: DecideTest.v Decide.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ColorTest.vo ColorTest.glob ColorTest.v.beautified ColorTest.required_vo: ColorTest.v Color.vo /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker
ColorTest.vos ColorTest.vok ColorTest.required_vos: ColorTest.v Color.vos /home/rocq/.opam/4.14.2+flambda/lib/rocq-runtime/rocqworker

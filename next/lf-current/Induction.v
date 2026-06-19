(** * Induction: 归纳证明 *)

(* ################################################################# *)
(** * 单独编译 *)

(** 在开始本章之前，我们需要把上一章中所有的定义都导入进来： *)

From LF Require Export Basics.

(** 为了让这个 [Require] 命令正常工作，Rocq 需要找到上一章
    （[Basics.v]）编译后的版本。这个编译后的版本被称为 [Basics.vo]，
    类似于从 [.java] 源文件编译出来的 [.class] 文件，
    以及从 [.c] 文件编译出来的 [.o] 文件。

    为了编译 [Basics.v] 并获得 [Basics.vo]，请首先确保文件 [Basics.v]、
    [Induction.v] 和 [_CoqProject] 都在当前目录下。

    [_CoqProject] 文件应当只包含以下这行内容：

      -Q . LF

    这会将当前目录（即包含 [Basics.v]、[Induction.v] 等文件的「.」目录）
    映射到前缀（或「【逻辑目录|Logical Directory】」）「LF」。
    Proof General、CoqIDE 和 VSRocq 会自动读取 [_CoqProject]，
    从而得知在何处寻找库 [LF.Basics] 对应的 [Basics.vo] 文件。

    一旦文件准备就绪，有多种方式可以从 IDE 中构建 [Basics.vo]，
    或者你也可以通过命令行来构建它。在 IDE 中……

     - 在 Proof General 中：通过将 Emacs 变量 [coq-compile-before-require]
       设置为 [t]，可以在向 PG 提交上面的 [Require] 行时自动进行编译。
       这也可以在菜单中找到：
       「Coq」 > 「Auto Compilation」 > 「Compile Before Require」。

     - 在 CoqIDE 中：在所有平台上，你都可以打开 [Basics.v]；
       然后在「Compile」菜单中点击「Compile Buffer」。

     - 对于 VSCode 用户，打开底部的终端面板，
       然后按照下面的命令行指令操作。（如果你下载了项目设置的 .tgz 文件，
       只需运行 `make` 就可以构建所有代码。）

    要在命令行中编译 [Basics.v]……

     - 首先，使用 Rocq 自带的 [rocq makefile] 工具生成 [Makefile]。
       （如果你是将整个卷作为一个归档文件获取的，[Makefile] 应该已经存在，
       你可以跳过这一步。）

         rocq makefile -f _CoqProject *.v -o Makefile

       每当你在该目录下添加或删除 Rocq 文件时，都应当重新运行该命令。

     - 现在，你可以通过运行 [make] 并指定对应的 [.vo] 文件作为目标，
       来编译 [Basics.v]：

         make Basics.vo

       如果不带任何参数，则可以编译目录下的所有文件：

         make

     - 在幕后，[make] 使用的是 Rocq 编译器 [rocq compile]。
       你也可以直接运行 [rocq compile]：

         rocq compile -Q . LF Basics.v

     - 由于 [make] 还会计算源文件之间的依赖关系，以便按正确的顺序编译它们，
       因此通常应优先选择 [make]，而不是显式运行 [rocq compile]。
       但作为最后的手段（但也并不算糟），你可以随着进度手动编译每个文件。
       例如，在开始本章的工作之前，你需要运行以下命令：

        rocq compile -Q . LF Basics.v

       然后，一旦你完成了本章，可以运行：

        rocq compile -Q . LF Induction.v

       来为下一章的工作做好准备。如果你删除了 .vo 文件，
       则需要再次按该顺序运行这两个命令。

    故障排除：

     - 对于上述许多方法，你需要确保 [rocq] 可执行文件在你的环境变量 [PATH] 中。

     - 如果你遇到有关缺失标识符的抱怨，可能是因为没有正确设置 Rocq 的
       「【加载路径|Load Path】」。命令 [Print LoadPath.] 可能有助于排查此类问题。

     - 当尝试编译后面的章节时，如果你看到类似以下的信息：

        Compiled library Induction makes inconsistent assumptions over
        library Basics

       常见的原因是库 [Basics] 被修改并重新编译了，但没有重新编译依赖它的 [Induction]。
       请重新编译 [Induction]；或者在受影响文件过多时重新编译所有内容
       （例如运行 [make]，如果这也不起作用，就运行 [make clean; make]）。

     - 如果你在本书后面的内容中遇到了缺失标识符的抱怨，可能也是因为没有正确设置
       Rocq 的「加载路径」。命令 [Print LoadPath.] 对解决此类问题可能会有所帮助。

       特别是，如果你看到类似以下的信息：

           Compiled library Foo makes inconsistent assumptions over
           library Bar

       请检查你的机器上是否安装了多个 Rocq。这可能是因为你在终端窗口中执行的命令
       （如 [rocq compile]）获取的是与 Proof General 或 CoqIDE 中执行时不同的 Rocq 版本。

     - 再给 CoqIDE 用户提一个建议：如果你看到类似 [Error: Unable to locate
       library Basics] 的信息，可能的原因是在「CoqIDE 内部」编译与在「命令行使用 [rocq]」
       编译之间存在不一致。这通常发生于系统上安装了两个不兼容的 Rocq 版本时
       （一个与 CoqIDE 关联，另一个与终端的 [rocq] 关联）。
       此情况的解决方法是仅使用 CoqIDE进行编译（即在菜单中选择「make」），
       并完全避免直接使用 [rocq]。 *)

(* ################################################################# *)
(** * 归纳证明 *)

(** 我们只用 [reflexivity] 就证明了 [0] 是 [+] 的左幺元。
    不过我们也注意到要证明它也是【右】幺元的话... *)

Theorem add_0_r_firsttry : forall n:nat,
  n + 0 = n.

(** ...事情就没这么简单了。只应用 [reflexivity] 的话不起作用，因为 [n + 0]
    中的 [n] 是任意未知数，所以在 [+] 的定义中 [match] 匹配无法被化简。  *)

Proof.
  intros n.
  simpl. (* Does nothing! *)
Abort.

(** 即便用 [destruct n] 分类讨论也不会有所改善：诚然，我们能够轻易地证明 [n = 0]
    时的情况；但在证明对于某些 [n'] 而言 [n = S n'] 时，我们又会遇到和此前相同的问题。 *)

Theorem add_0_r_secondtry : forall n:nat,
  n + 0 = n.
Proof.
  intros n. destruct n as [| n'] eqn:E.
  - (* n = 0 *)
    reflexivity. (* 虽然目前还没啥问题... *)
  - (* n = S n' *)
    simpl.       (* ...不过我们又卡在这儿了 *)
Abort.

(** 虽然还可以用 [destruct n'] 再推进一步，但由于 [n] 可以任意大，
    如果照这个思路继续证明的话，我们永远也证不完。 *)

(** 为了证明这种关于数字、列表等归纳定义的集合的有趣事实，
    我们通常需要一个更强大的推理原理：【归纳】。

    回想一下 【自然数的归纳法则】，你也许曾在高中的数学课上，在某门离散数学课上或
    在其它类似的课上学到过它：若 [P(n)] 为关于自然数的命题，而当我们想要证明 [P]
    对于所有自然数 [n] 都成立时，可以这样推理：
         - 证明 [P(O)] 成立；
         - 证明对于任何 [n']，若 [P(n')] 成立，那么 [P(S n')] 也成立。
         - 最后得出 [P(n)] 对于所有 [n] 都成立的结论。

    在 Rocq 中的步骤也一样，但我们通常会以相反的顺序遇到它们：
    我们以证明 [P(n)] 对于所有 [n] 都成立的目标开始，
    然后通过应用 [induction] 策略把它分为两个子目标：一个是我们必须证明
    [P(O)] 成立，另一个是我们必须证明 [P(n') -> P(S n')]。
    下面就是对该定理的用法：... *)

Theorem add_0_r : forall n:nat, n + 0 = n.
Proof.
  intros n. induction n as [| n' IHn'].
  - (* n = 0 *)    reflexivity.
  - (* n = S n' *) simpl. rewrite -> IHn'. reflexivity.  Qed.

(** 和 [destruct] 一样，[induction] 策略也能通过 [as...] 子句为引入到
    子目标中的变量指定名字。由于这次有两个子目标，因此 [as...] 有两部分，用 [|]
    隔开。（严格来说，我们可以忽略 [as...] 子句，Rocq 会为它们选择名字。
    然而在实践中这样不好，因为让 Rocq 自行选择名字的话更容易导致理解上的困难。）

    在第一个子目标中 [n] 被 [0] 所取代。由于没有新的变量会被引入，因此 [as ...]
    字句的第一部分为空；而当前的目标会变成 [0 + 0 = 0]：使用化简就能得到此结论。

    在第二个子目标中，[n] 被 [S n'] 所取代，而对 [n'] 的归纳假设（Inductive
    Hypothesis），即 [n' + 0 = n'] 则以 [IHn'] 为名被添加到了语境中。
    这两个名字在 [as...] 子句的第二部分中指定。在此语境中，待证目标变成了
    [S n' = (S n') + 0]，它可被化简为 [S n' = S (n' + 0)]，而此结论可通过
    [IHn'] 得出。 *)

Theorem minus_n_n : forall n,
  minus n n = 0.
Proof.
  (* WORKED IN CLASS *)
  intros n. induction n as [| n' IHn'].
  - (* n = 0 *)
    simpl. reflexivity.
  - (* n = S n' *)
    simpl. rewrite -> IHn'. reflexivity.  Qed.

(** （其实在这些证明中我们并不需要 [intros]：当 [induction]
    策略被应用到包含量化变量的目标中时，它会自动将需要的变量移到语境中。） *)

(** **** Exercise: 2 stars, standard, especially useful (basic_induction)

    用归纳法证明以下命题。你可能需要之前的证明结果。 *)

Theorem mul_0_r : forall n:nat,
  n * 0 = 0.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem plus_n_Sm : forall n m : nat,
  S (n + m) = n + (S m).
Proof.
  (* FILL IN HERE *) Admitted.

Theorem add_comm : forall n m : nat,
  n + m = m + n.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem add_assoc : forall n m p : nat,
  n + (m + p) = (n + m) + p.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** **** Exercise: 2 stars, standard (double_plus)

    考虑以下函数，它将参数乘以二： *)

Fixpoint double (n:nat) :=
  match n with
  | O => O
  | S n' => S (S (double n'))
  end.

(** 用归纳法证明以下关于 [double] 的简单事实： *)

Lemma double_plus : forall n, double n = n + n .
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** **** Exercise: 2 stars, standard (eqb_refl)

    以下定理将 [nat] 上的「【计算等价|Computational Equality】」[=?]
    与 [bool] 上的「【定义等价|Definitional Equality】」[=] 联系起来。 *)

Theorem eqb_refl : forall n : nat,
  (n =? n) = true.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** **** Exercise: 2 stars, standard, optional (even_S)

    我们的 [even n] 定义中，对 [n - 2] 的递归调用有些不便。
    这使得在对 [n] 进行归纳来证明关于 [even n] 的性质时变得更加困难，
    因为我们可能会需要一个关于 [n - 2] 的「【归纳假设|Induction Hypothesis】」。
    以下引理给出了 [even (S n)] 的另一种刻画，它能更好地与归纳协同工作： *)

Theorem even_S : forall n : nat,
  even (S n) = negb (even n).
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(* ################################################################# *)
(** * 证明里的证明 *)

(** 和在非形式化的数学中一样，在 Rocq 中，大的证明通常会被分为一系列定理，
    后面的定理引用之前的定理。但有时一个证明会需要一些繁杂琐碎的事实，
    而这些事实缺乏普遍性，以至于我们甚至都不应该给它们单独取顶级的名字。
    此时，如果能在需要的地方直接使用该事实，随后在单独的步骤中证明它，
    就会非常方便。[replace] 策略能让我们做到这一点。 *)

Theorem mult_0_plus' : forall n m : nat,
  (n + 0 + 0) * m = n * m.
Proof.
  intros n m.
  replace (n + 0 + 0) with n.
  - reflexivity.
  - rewrite add_comm. simpl. rewrite add_comm. reflexivity.
Qed.

(** 策略 [replace e1 with e2] 会引入两个子目标。
    第一个子目标与我们调用 [replace] 时的目标相同，只是其中的 [e1]
    被替换成了 [e2]。第二个子目标则是等式 [e1 = e2] 本身。 *)

(** 举例来说，假设我们要证明 [(n + m) + (p + q) = (m + n) + (p + q)]。
    等式 [=] 两边唯一的区别就是内层第一个 [+] 的参数 [m] 和 [n] 交换了位置，
    因此我们似乎应当能够使用加法交换律（[add_comm]）来将一侧改写为另一侧。
    然而，[rewrite] 策略对于改写作用的「位置」并不够智能。
    这里一共使用了三次 [+]，而执行 [rewrite -> add_comm] 只会影响「最外层」的那个…… *)

Theorem plus_rearrange_firsttry : forall n m p q : nat,
  (n + m) + (p + q) = (m + n) + (p + q).
Proof.
  intros n m p q.
  (* 我们只需要将 (m + n) 交换为 (n + m)... 看起来 add_comm 能搞定！*)
  rewrite add_comm.
  (* 搞不定... Rocq 选错了要改写的加法！ *)
Abort.

(** 为了在需要的地方使用 [add_comm]，我们可以使用 [replace]
    将 [n + m] 改写为 [m + n]，然后使用 [add_comm]
    来证明 [n + m = m + n]。 *)

Theorem plus_rearrange : forall n m p q : nat,
  (n + m) + (p + q) = (m + n) + (p + q).
Proof.
  intros n m p q.
  replace (n + m) with (m + n).
  - reflexivity.
  - rewrite add_comm. reflexivity.
Qed.

(* ################################################################# *)
(** * 形式化证明 vs. 非形式化证明 *)

(** 「【非形式化证明是算法，形式化证明是代码。】」 *)

(** 数学声明的成功证明由什么构成？

    这个问题已经困扰了哲学家数千年，不过这儿有个还算凑合的定义：
    数学命题 [P] 的证明是一段书面（或口头）的文本，它对 [P]
    的真实性进行无可辩驳的论证，逐步说服读者或听者使其确信 [P] 为真。
    也就是说，证明是一种交流行为。

    交流活动会涉及不同类型的读者。一方面，「读者」可以是像 Rocq 这样的程序，
    此时灌输的「确信」是 [P] 能够从一个确定的，由形式化逻辑规则组成的集合中
    机械地推导出来，而证明则是指导程序检验这一事实的方法。这种方法就是
    【形式化】证明。

    另一方面，读者也可以是人类，这种情况下证明可以用英语或其它自然语言写出，
    因此必然是【非形式化】的，此时成功的标准不太明确。一个「有效的」证明是让读者
    相信 [P]。但同一个证明可能被很多不同的读者阅读，其中一些人可能会被某种特定
    的表述论证方式说服，而其他人则不会。有些读者太爱钻牛角尖，或者缺乏经验，
    或者只是单纯地过于愚钝，说服他们的唯一方法就是细致入微地进行论证。
    不过熟悉这一领域的读者可能会觉得所有细节都太过繁琐，让他们无法抓住
    整体的思路；他们想要的不过是抓住主要思路，因为相对于事无巨细的描述而言，
    让他们自行补充所需细节更为容易。总之，我们没有一个通用的标准，
    因为没有一种编写非形式化证明的方式能够说服所能顾及的每一个读者。

    然而在实践中，数学家们已经发展出了一套用于描述复杂数学对象的约定和习语，
    这让交流（至少在特定的社区内）变得十分可靠。这种约定俗成的交流形式已然成风，
    它为证明的好坏给出了清晰的判断标准。

    由于我们在本课程中使用 Rocq，因此会重度使用形式化证明。但这并不意味着我们
    可以完全忽略掉非形式化的证明过程！形式化证明在很多方面都非常有用，
    不过它们对人类之间的思想交流而言 【并不】 十分高效。 *)

(** 例如，下面是一段加法结合律的证明： *)

Theorem add_assoc' : forall n m p : nat,
  n + (m + p) = (n + m) + p.
Proof. intros n m p. induction n as [| n' IHn']. reflexivity.
  simpl. rewrite IHn'. reflexivity.  Qed.

(** Rocq 对此表示十分满意。然而人类却很难理解它。
    我们可以用注释和标号让它的结构看上去更清晰一点... *)

Theorem add_assoc'' : forall n m p : nat,
  n + (m + p) = (n + m) + p.
Proof.
  intros n m p. induction n as [| n' IHn'].
  - (* n = 0 *)
    reflexivity.
  - (* n = S n' *)
    simpl. rewrite IHn'. reflexivity.   Qed.

(** 而且如果你习惯了 Rocq，你可能会在脑袋里逐步过一遍策略，并想象出
    每一处语境和目标栈的状态。不过若证明再复杂一点，那就几乎不可能了。

    一个（迂腐的）数学家可能把证明写成这样： *)

(** - 【定理】：对于任何 [n]、[m] 和 [p]，

      n + (m + p) = (n + m) + p.

    【证明】：对 [n] 使用归纳法。

    - 首先，设 [n = 0]。我们必须证明

        0 + (m + p) = (0 + m) + p.

      此结论可从 [+] 的定义直接得到。

    - 然后，设 [n = S n']，其中

        n' + (m + p) = (n' + m) + p.

      我们必须证明

        (S n') + (m + p) = ((S n') + m) + p.

      根据 [+] 的定义，该式可写成

        S (n' + (m + p)) = S ((n' + m) + p),

      它由归纳假设直接得出。【证毕】。 *)

(** 证明的总体形式大体类似，当然这并非偶然：Rocq 的设计使其 [induction]
    策略会像数学家写出的标号那样，按相同的顺序生成相同的子目标。但在细节上则有
    明显的不同：形式化证明在某些方面更为明确（例如对 [reflexivity] 的使用），
    但在其它方面则不够明确（特别是 Rocq 证明中任何一处的「证明状态」都是完全
    隐含的，而非形式化证明则经常反复提醒读者目前证明进行的状态）。 *)

(** **** Exercise: 2 stars, advanced, optional (add_comm_informal)

    将你对 [add_comm] 的解答翻译成非形式化证明：

    定理：加法满足交换律。

    证明：(* FILL IN HERE *)
*)

(* Do not modify the following line: *)
Definition manual_grade_for_add_comm_informal : option (nat*string) := None.
(** [] *)

(** **** Exercise: 2 stars, standard, optional (eqb_refl_informal)

    以 [add_assoc] 的非形式化证明为范本，写出以下定理的非形式化证明。
    不要只是用中文来解释 Rocq 策略！

    定理：对于任何 [n]，均有 [(n =? n) = true]。

    证明： (* FILL IN HERE *)
*)

(* Do not modify the following line: *)
Definition manual_grade_for_eqb_refl_informal : option (nat*string) := None.
(** [] *)

(* ################################################################# *)
(** * 更多练习 *)

(** **** Exercise: 3 stars, standard, especially useful (mul_comm)

    用 [replace] 来帮助证明  [add_shuffle3]。你应该不需要使用归纳法。 *)

Theorem add_shuffle3 : forall n m p : nat,
  n + (m + p) = m + (n + p).
Proof.
  (* FILL IN HERE *) Admitted.

(** 现在证明乘法交换律。（你在证明过程中可能想要定义并证明一个辅助定理。
    提示：[n * (1 + k)] 是什么？） *)

Theorem mul_comm : forall m n : nat,
  m * n = n * m.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** **** Exercise: 3 stars, standard, optional (more_exercises)

    找一张纸。对于以下定理，首先请 【思考】 (a) 它能否能只用化简和改写来证明，
    (b) 它还需要分类讨论（[destruct]），以及 (c) 它还需要归纳证明。先写下你的
    预判，然后填写下面的证明（你的纸不用交上来，这只是鼓励你先思考再行动！） *)

Theorem leb_refl : forall n:nat,
  (n <=? n) = true.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem zero_neqb_S : forall n:nat,
  0 =? (S n) = false.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem andb_false_r : forall b : bool,
  andb b false = false.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem S_neqb_0 : forall n:nat,
  (S n) =? 0 = false.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem mult_1_l : forall n:nat, 1 * n = n.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem all3_spec : forall b c : bool,
  orb
    (andb b c)
    (orb (negb b)
         (negb c))
  = true.
Proof.
  (* FILL IN HERE *) Admitted.

Theorem mult_plus_distr_r : forall n m p : nat,
  (n + m) * p = (n * p) + (m * p).
Proof.
  (* FILL IN HERE *) Admitted.

Theorem mult_assoc : forall n m p : nat,
  n * (m * p) = (n * m) * p.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(* ################################################################# *)
(** * 从 Nat 到 Bin 再到 Nat *)

(** 回顾我们在 [Basics] 中定义的 [bin] 类型： *)

Inductive bin : Type :=
  | Z
  | B0 (n : bin)
  | B1 (n : bin)
.
(** 在开始下一个练习之前，请将下面 [incr] 和 [bin_to_nat]
    的占位定义替换为你在 [Basics] 中给出的解答。
    这样本文件就可以独立进行评分。 *)

Fixpoint incr (m:bin) : bin
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Fixpoint bin_to_nat (m:bin) : nat
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

(** 在 [Basics] 一章中，我们对 [bin_to_nat] 进行了一些单元测试，
    但没有证明其正确性。现在我们将证明它。 *)

(** **** Exercise: 3 stars, standard, especially useful (binary_commute)

    证明下图可交换：

                            incr
              bin ----------------------> bin
               |                           |
    bin_to_nat |                           |  bin_to_nat
               |                           |
               v                           v
              nat ----------------------> nat
                             S

    也就是说，一个二进制数先自增然后将它转换为（一进制）自然数，和先将它转换为
    自然数后再自增会产生相同的结果。

    如果你想修改之前对 [incr] 或 [bin_to_nat] 的定义，让此性质更容易证明，
    请随意！ *)

Theorem bin_to_nat_pres_incr : forall b : bin,
  bin_to_nat (incr b) = 1 + bin_to_nat b.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(** **** Exercise: 3 stars, standard (nat_bin_nat) *)

(** 编写一个函数，将自然数转换为二进制数。 *)

Fixpoint nat_to_bin (n:nat) : bin
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

(** 证明：如果我们从任意 [nat] 开始，将它转换为 [bin]，然后再转换回来，
    就会得到开始时的同一个 [nat]。

    提示：这个证明应当能顺利地使用之前关于 [incr] 的练习作为
    【引理|Lemma】来完成。如果不能，请重新审视所涉及函数的定义，
    并考虑它们是否比必要的更复杂：归纳证明的形状会匹配被验证程序的
    【递归结构|Recursive Structure】，所以请让递归尽可能简单。 *)

Theorem nat_bin_nat : forall n, bin_to_nat (nat_to_bin n) = n.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(* ################################################################# *)
(** * 从二进制到自然数再回到二进制（进阶） *)

(** 反方向，即从一个 [bin] 开始，将它转换为 [nat]，然后再转换回 [bin]，
    这样会出问题。也就是说，以下「【定理|Theorem】」并不成立。 *)

Theorem bin_nat_bin_fails : forall b, nat_to_bin (bin_to_nat b) = b.
Abort.

(** 让我们探究一下为什么该定理会失败，以及如何证明它的一个修改版本。
    我们会先从一些看似无关、但最终会相关的引理开始。 *)

(** **** Exercise: 2 stars, advanced (double_bin) *)

(** 证明这个关于 [double] 的引理，它是我们在本章前面定义的。 *)

Lemma double_incr : forall n : nat, double (S n) = S (S (double n)).
Proof.
  (* FILL IN HERE *) Admitted.

(** 现在为 [bin] 定义一个类似的倍增函数。 *)

Definition double_bin (b:bin) : bin
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

(** 检查你的函数是否正确地将零倍增。 *)

Example double_bin_zero : double_bin Z = Z.
(* FILL IN HERE *) Admitted.

(** 证明这个与 [double_incr] 对应的引理。 *)

Lemma double_incr_bin : forall b,
    double_bin (incr b) = incr (incr (double_bin b)).
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(** 让我们回到想要的定理： *)

Theorem bin_nat_bin_fails : forall b, nat_to_bin (bin_to_nat b) = b.
Abort.

(** 该定理会失败，是因为存在某些 [bin]，使得我们不一定会得到
    【原始】的 [bin]，而是会得到一个「【等价|Equivalent】」的 [bin]。
    （我们有意在这里不定义这个概念，留给你思考。）

    请在下面的注释中解释为什么会发生这种失败。你的解释不会被评分，
    但在继续下一部分之前，在脑中把它弄清楚很重要。如果你卡在这里，
    请想一想 [double_bin] 的其它实现：它们可能无法满足 [double_bin_zero]，
    但在其它方面看起来是正确的。 *)

(* FILL IN HERE *)

(** 为了解决这个问题，我们可以引入一个【规范化】函数，它会从所有等价的
    [bin] 中选出最简单的那个。然后我们可以证明，从 [bin] 转换到 [nat]
    再转换回来，会产生那个经过规范化的、最简单的 [bin]。 *)

(** **** Exercise: 4 stars, advanced (bin_nat_bin) *)

(** 定义 [normalize]。你需要让它的定义尽可能简单，以便之后的证明能够顺利进行。
    不要使用 [bin_to_nat] 或 [nat_to_bin]，但要使用 [double_bin]。

    提示：组织递归，使其【总是】到达 [bin] 的末尾，并且【只】处理每一位一次。
    不要试图「向后查看」未来的位。 *)

Fixpoint normalize (b:bin) : bin
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

(** 在继续之前，最好做一些 [Example] 证明，检查你对 [normalize] 的定义是否按
    预期工作。它们不会被评分，但请在下面填上它们。 *)

(* FILL IN HERE *)

(** 最后，证明主定理。归纳情况可能有点棘手。

    提示：先尝试证明主陈述，看看你会在哪里卡住，再看看能否找到一个引理
    （它或许需要自己的归纳证明），从而让主证明取得进展。我们有一个用于 [B0]
    情况的引理（它也会用到 [double_incr_bin]），以及另一个用于 [B1]
    情况的引理。 *)

Theorem bin_nat_bin : forall b, nat_to_bin (bin_to_nat b) = normalize b.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(* 2026-06-19 18:13 *)

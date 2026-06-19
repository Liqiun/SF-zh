(** * Basics: Rocq 函数式编程 *)

(* REMINDER:

          ##############################
          ###  请勿公开发布习题解答  ###
          ##############################

   （原因见 [Preface]。）
*)

(* ################################################################# *)
(** * 引言 *)

(** 【函数式风格|Functional Style】的编程建立在简单的、日常的数学直觉之上：
    若一个过程或方法没有副作用，那么在忽略效率的前提下，
    我们需要理解的一切便只剩下它如何将输入映射到输出了
    —— 也就是说，我们只需将它视作一种计算数学函数的具体方法即可。
    这也是「函数式编程」中「函数式」一词的含义之一。
    程序与简单数学对象之间这种直接的联系，
    同时支撑了对程序行为进行形式化证明的正确性，以及非形式化论证的可靠性。

    函数式编程中「函数式」一词的另一个含义是它强调把函数作为【一等】的值
    —— 这类值可以作为参数传递给其它函数，可以作为结果返回，
    也可以包含在数据结构中等等。这种将函数当做数据的方式，
    产生了大量强大而有用的编程【习语|Idiom】。

    其它常见的函数式语言特性，还有能让构造和处理丰富数据结构更加简单的
    【代数数据类型|Algebraic Data Type】，相应的【模式匹配|Pattern Matching】，
    以及用来支持抽象和代码复用的【多态类型系统|Polymorphic Type System】。
    Rocq 提供了所有这些特性。

    本章的前半部分介绍了 Rocq 原生的函数式编程语言 _Gallina_ 中最基本的元素，
    后半部分则介绍了一些基本【策略|Tactic】，它可用于证明 Gallina 程序的简单性质。 *)

(* ================================================================= *)
(** ** 作业提交指南 *)

(** 如果你在课堂中使用《软件基础》，你的讲师可能会用自动化脚本来为你的作业评分。
    为了让这些脚本能够正常工作（这样你才能拿到全部学分！），请认真遵循以下规则：

      - 评分脚本在提取你提交的 [.v] 文件时会用到其中的特殊标记。因此请勿修改练习的
        「分隔标记」，如练习的标题、名称、以及末尾的 [[]] 等等。
      - 不要删除练习。如果你想要跳过某个练习（例如它标记为「可选」或你无法解决它），
        可以在 [.v] 文件中留下部分证明，这没关系，不过此时请确认它以 [Admitted]
        结尾（不要用 [Abort] 之类的东西）。
      - 你也可以在解答中使用附加定义（如辅助函数，需要的引理等）。
        你可以将它们放在练习的头部和你要证明的定理之间。
      - 如果你为了证明某定理而需要引入一个额外引理，且未能证明该引理，
        请确保该引理与使用它的原定理都以 [Admitted] 而非 [Qed] 结尾。
        这样能使在你利用原定理解决其他练习时得到部分分数。

    你或许注意到每一章都附带有一个【测试脚本】来自动计算该章节已完成
    的作业的分数。这些脚本一般只作为自动评分工具，但你也可以用它们在提交前
    再一次确认作业格式的正确性。
    你可以在一个终端窗口中输入 "[make BasicsTest.vo]" 或下面的命令来运行这些
    测试脚本：

       rocq compile -Q . LF Basics.v
       rocq compile -Q . LF BasicsTest.v

    有关如何解读测试脚本的输出的更多信息，请参阅本章末尾。

    你并不需要提交 [BasicsTest.v] 这种测试脚本（也不需要提交前言 [Preface.v]）。

    如果你的班级使用 Canvas 系统来提交作业……
      - 如果你提交了多个不同版本的作业，你可能会注意到它们在系统中有着
        不同的名字。这是正常情况，只有最新的提交会被评分。
      - 如果你需要同时提交多个文件（例如一周的作业中包含多个不同的章节），
        你需要点击评论框上面的「Add another file」添加多个文件，
        【一次性】提交所有的文件。 *)

(* ################################################################# *)
(** * 数据与函数 *)

(* ================================================================= *)
(** ** 枚举类型 *)

(** Rocq 的一个不同寻常之处在于它【极小】的内建特性集合。
    比如，Rocq 并未提供通常的原语（atomic）类型（如布尔、整数、字符串等），
    而是提供了一种极为强大的，可以从头定义新的数据类型的机制
    —— 上面所有常见的类型都是由它定义而产生的实例。

    当然，Rocq 发行版同时也提供了内容丰富的标准库，其中定义了布尔值、
    数值，以及如列表、散列表等许多通用的数据结构。
    不过这些库中的定义并没有任何神秘之处，也没有原语（Primitive）的特点。
    为了说明这一点，我们并未在本课程中直接使用标准库中的数据类型，
    而是在整个教程中重新定义了其中的绝大部分。 *)

(* ================================================================= *)
(** ** 一周七日 *)

(** 让我们从一个非常简单的例子开始，看看这种定义机制是如何工作的。
    以下声明会告诉 Rocq 我们定义了一个数据集合，即一个【类型|Type】。 *)

Inductive day : Type :=
  | monday
  | tuesday
  | wednesday
  | thursday
  | friday
  | saturday
  | sunday.

(** 这个新的类型名为 [day]，成员包括 [monday]、[tuesday] 等等。

    定义了 [day] 之后, 我们就能写一些操作星期的函数了。 *)

Definition next_working_day (d:day) : day :=
  match d with
  | monday    => tuesday
  | tuesday   => wednesday
  | wednesday => thursday
  | thursday  => friday
  | friday    => monday
  | saturday  => monday
  | sunday    => monday
  end.

(** 注意，这里显式声明了函数的参数和返回类型。
    和大多数函数式编程语言一样，如果没有显式指定类型，Rocq 通常会自己通过
    【类型推断|Type Inference】得出。不过我们会标上类型使其更加易读。 *)

(** 定义了函数之后，我们接下来应该用一些例子来检验它。
    实际上，在 Rocq 中，一共有三种不同的检验方式：第一种，我们可以用 [Compute]
    指令来计算包含 [next_weekday] 的复合表达式： *)

Compute (next_working_day friday).
(* ==> monday : day *)

Compute (next_working_day (next_working_day saturday)).
(* ==> tuesday : day *)

(** （我们在注释中写出 Rocq 返回的结果。如果你身边就有电脑，
    不妨选一个你喜欢的 IDE（安装指南见 [Preface]），
    自己用 Rocq 解释器试一试。从本书附带的 Rocq 源码中载入 [Basics.v]
    文件，找到上面的例子，提交给 Rocq，然后观察结果。） *)

(** 第二种，我们可以将【期望】的结果写成 Rocq 的【示例|Example】： *)

Example test_next_working_day:
  (next_working_day (next_working_day saturday)) = tuesday.

(** 该声明做了两件事：首先它断言 [saturday] 之后的第二个工作日是
    [tuesday]；然后它为该断言取了名字以便之后引用它。
    定义好断言后，我们还可以让 Rocq 来【验证|Verify】它，就像这样： *)

Proof. simpl. reflexivity.  Qed.

(** 具体细节目前并不重要，不过这段代码基本上可以读作
    「若等式两边的求值结果相同，该断言即可得证。」

    第三，我们可以让 Rocq 从 [Definition] 中【提取|Extract】
    出用其它更加常规的编程语言编写的程序
    （如 OCaml、Scheme、Haskell 等），它们拥有高性能的编译器。
    这种能力非常有用，我们可以通过它将 Gallina 编写的 【证明正确】
    的算法转译成高效的机器码。

    （诚然，我们必须信任 OCaml/Haskell/Scheme 的编译器，
    以及 Rocq 提取工具自身的正确性，然而比起现在大多数软件的开发方式，
    这也是很大的进步了。）

    实际上，这就是 Rocq 最主要的使用方式之一。
    在之后的章节中我们会回到这一主题上来。 *)

(** 下面这行 [Require Export] 语句告诉 Rocq 使用标准库中的 [String] 模块。
    我们将在后面的章节中使用字符串进行各种操作，但在这里我们需要 [Require] 它，
    以便评分脚本可以将其用于内部用途。*)
From Stdlib Require Export String.

(* ================================================================= *)
(** ** 布尔值 *)

(** 通过类似的方式，我们可以为布尔值定义常见的 [bool] 类型，
    它包括 [true] 和 [false] 两个成员。 *)

Inductive bool : Type :=
  | true
  | false.

(** 布尔值的函数可按照同样的方式来定义： *)

Definition negb (b:bool) : bool :=
  match b with
  | true => false
  | false => true
  end.

Definition andb (b1:bool) (b2:bool) : bool :=
  match b1 with
  | true => b2
  | false => false
  end.

Definition orb (b1:bool) (b2:bool) : bool :=
  match b1 with
  | true => true
  | false => b2
  end.

(** （虽然我们正尝试从零开始定义布尔类型，
    但由于 Rocq 的标准库中也提供了布尔类型的默认实现，以及大量有用的函数和引理。
    我们会尽量让自己的定义和定理的名字与标准库保持一致。） *)

(** 最后两个定义展示了 Rocq 中定义多参函数的语法。
    对应的多参【应用|Application】的语法在下面的【单元测试】中展示，
    它们为 [orb] 函数构成了完整的规范：一个真值表。 *)

Example test_orb1:  (orb true  false) = true.
Proof. simpl. reflexivity.  Qed.
Example test_orb2:  (orb false false) = false.
Proof. simpl. reflexivity.  Qed.
Example test_orb3:  (orb false true)  = true.
Proof. simpl. reflexivity.  Qed.
Example test_orb4:  (orb true  true)  = true.
Proof. simpl. reflexivity.  Qed.

(** 我们也可以为刚定义的布尔运算引入更加熟悉的中缀语法。
    [Notation] 指令能为既有的定义赋予新的符号记法。 *)

Notation "x && y" := (andb x y).
Notation "x || y" := (orb x y).

Example test_orb5:  false || false || true = true.
Proof. simpl. reflexivity. Qed.

(** 【关于记法的说明】：在 [.v] 文件中，我们用方括号来界定注释中的
    Rocq 代码片段；这种约定也在 [rocq doc] 文档工具中使用，
    它能让代码与周围的文本从视觉上区分开来。
    在 HTML 版的文件中，这部分文本会以不带方括号的【另一种字体】显示。 *)

(** 下面的例子展示了 Rocq 的编程语言的另一个特性: 条件表达式... *)

Definition negb' (b:bool) : bool :=
  if b then false
  else true.

Definition andb' (b1:bool) (b2:bool) : bool :=
  if b1 then b2
  else false.

Definition orb' (b1:bool) (b2:bool) : bool :=
  if b1 then true
  else b2.

(** Rocq 的条件表达式与其他语言非常相似，只有一点小小的扩展：

    由于 [bool] 类型并不是内建类型，
    Rocq 实际上支持对【任何】归纳定义的双子句表达式使用「if」表达式。
    当条件求值后得到的是 [Inductive] 归纳定义的第一个子句的
    「【构造子|Constructor】」，那么条件就会被认为是「真」[true]
    （在这里恰巧第一个分支的构造子被称为「真」[true]；
    如果求值后得到的是第二个子句，那么条件就被认为是「假」[false]）。 *)

(** 例如，我们可以定义以下数据类型 [bw]，其中包含两个构造子，
    分别表示黑色 ([b]) 和白色 ([w])，并定义一个函数 [invert]，
    该函数使用条件语句反转此类型的值。 *)

Inductive bw : Type :=
  | bw_black
  | bw_white.

Definition invert (x: bw) : bw :=
  if x then bw_white
  else bw_black.

Compute (invert bw_black).
(* ==> bw_white : bw *)

Compute (invert bw_white).
(* ==> bw_black : bw *)

(** **** Exercise: 1 star, standard (nandb)

    指令 [Admitted] 被用作不完整证明的占位符。
    我们会在练习中用它来表示你需要完成的部分。你的任务就是将 [Admitted]
    替换为具体的证明。

    移除「[Admitted.]」并补完以下函数的定义，然后确保下列每一个 [Example]
    中的断言都能被 Rocq 验证通过。（即仿照上文 [orb] 测试的格式补充证明，
    并确保 Rocq 接受它。）此函数应在两个输入中的任意一个（或者都）包含
    [false] 时返回 [true] 。

    提示：如果 [simpl] 在你的证明中未能化简目标，那是因为你可能并未使用
    [match] 表达式定义你的 [nandb]。尝试使用另一种 [nandb] 的定义方式，
    或者直接跳过 [simpl] 直接使用 [reflexivity]。我们后面会解释为什么
    会发生这种情况。 *)

Definition nandb (b1:bool) (b2:bool) : bool
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Example test_nandb1:               (nandb true false) = true.
(* FILL IN HERE *) Admitted.
Example test_nandb2:               (nandb false false) = true.
(* FILL IN HERE *) Admitted.
Example test_nandb3:               (nandb false true) = true.
(* FILL IN HERE *) Admitted.
Example test_nandb4:               (nandb true true) = false.
(* FILL IN HERE *) Admitted.
(** [] *)

(** **** Exercise: 1 star, standard (andb3)

    与此前相同，完成下面的 [andb3] 函数。
    此函数应在所有输入均为 [true] 时返回 [true]，否则返回 [false]。 *)

Definition andb3 (b1:bool) (b2:bool) (b3:bool) : bool
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Example test_andb31:                 (andb3 true true true) = true.
(* FILL IN HERE *) Admitted.
Example test_andb32:                 (andb3 false true true) = false.
(* FILL IN HERE *) Admitted.
Example test_andb33:                 (andb3 true false true) = false.
(* FILL IN HERE *) Admitted.
Example test_andb34:                 (andb3 true true false) = false.
(* FILL IN HERE *) Admitted.
(** [] *)

(* ================================================================= *)
(** ** 类型 *)

(** Rocq 中的每个表达式都有类型，它描述了该表达式所计算的东西的类别。
    [Check] 指令会让 Rocq 显示一个表达式的类型。 *)

Check true.
(* ===> true : bool *)

(** 如果在被 [Check] 的表达式后加上一个冒号和你想验证的类型，那么 Rocq 会
    验证该表达式是否属于你提供的类型。当两者不一致时，Rocq 会报错并终止执行。 *)

Check true
  : bool.
Check (negb true)
  : bool.

(** 像 [negb] 这样的函数本身也是数据值，就像 [true] 和 [false] 一样。
    它们的类型被称为【函数类型|Function Types】，用带箭头的类型表示。 *)

Check negb
  : bool -> bool.

(** [negb] 的类型写作 [bool -> bool]，读做「[bool] 箭头 [bool]」，
    可以理解为「给定一个 [bool] 类型的输入，该函数产生一个 [bool] 类型的输出。」
    同样，[andb] 的类型写作 [bool -> bool -> bool]，可以理解为
    「给定两个 [bool] 类型的输入，该函数产生一个 [bool] 类型的输出。」 *)

(* ================================================================= *)
(** ** 从旧类型构造新类型 *)

(** 到目前为止，我们定义的类型都是「【枚举类型|Enumerated Type】」：
    它们的定义显式地枚举了一个元素的有限集，叫做【构造子|Constructor】。
    下面是一个更加有趣的类型定义 [color]，其中一个构造子接受一个参数： *)

Inductive rgb : Type :=
  | red
  | green
  | blue.

Inductive color : Type :=
  | black
  | white
  | primary (p : rgb).

(** 我们来仔细研究一下。

    [Inductive] 归纳定义做了两件事：

    - 它引入了一组新的【构造子|Constructor】。例如，[red]、
      [primary]、[true]、[false]、[monday] 等都是构造子。

    - 它将这些构造子分组到一个新命名的类型中，例如 [bool]、[rgb]、或 [color].

    【构造子表达式|Constructor Expression】通过将构造子应用到一个或多个构造子表达式上构成，
    它还要遵守构造子参数的声明数量和类型。例如，以下是有效的构造子表达式……
        - [red]
        - [true]
        - [primary red]
        - 等等……
    ……但这些不是：
        - [red primary]
        - [true red]
        - [primary (primary red)]
        - 等等……
*)

(** 具体来说，[rgb] 和 [color] 的定义描述了如何构造这两个集合中的构造子表达式：

    - 构造子表达式 [red]、[green] 和 [blue] 属于集合 [rgb]；
    - 构造子表达式 [black] 和 [white] 属于集合 [color]；
    - 若 [p] 是属于 [rgb] 的构造子表达式，则 [primary p]（读作「构造子 [primary]
      应用于参数 [p]」）是属于集合 [color] 的构造子表达式；且
    - 通过这些方式构造的构造子表达式【只属于】集合 [rgb] 和 [color]。 *)

(** 我们可以像之前的 [day] 和 [bool] 那样用模式匹配为 [color] 定义函数。 *)

Definition monochrome (c : color) : bool :=
  match c with
  | black => true
  | white => true
  | primary p => false
  end.

(** 鉴于 [primary] 构造子接收一个参数，匹配到 [primary] 的模式应当带有一个
    变量或常量。变量可以取任意名称，如上文所示；常量需有适当的类型，例如： *)

Definition isred (c : color) : bool :=
  match c with
  | black => false
  | white => false
  | primary red => true
  | primary _ => false
  end.

(** 这里的模式 [primary _] 是「构造子 [primary] 应用到除 [red]
    之外的任何 [rgb] 构造子上」的简写形式 *)

(** （通配模式 [_] 的效果与 [monochrome] 定义中的【哑|dummy|】
    模式变量 [p] 相同。） *)

(* ================================================================= *)
(** ** 模块 *)

(** Rocq 提供了【模块系统|Module System】来辅助组织大型开发。
    它的绝大多数特性我们都不会用到，但其中一点在这里很有用：
    如果我们将一系列声明包含在 [Module X] 和 [End X] 标记之间，
    那么在 [End] 之后的文件剩余部分中，这些定义就可以通过像 [X.foo]
    这样的名称而非 [foo] 来引用。我们将利用这一特性来限制定义的
    【作用域|Scope】，以便我们可以自由地重用名称。 *)

Module Playground.
  Definition foo : rgb := blue.
End Playground.

Definition foo : bool := true.

Check Playground.foo : rgb.
Check foo : bool.

(* ================================================================= *)
(** ** 元组 *)

Module TuplePlayground.

(** 一个多参数的单构造子可以用来创建元组类型。例如，为了让一个
    半字节（nybble）表示四个比特。我们首先定义一个 [bit] 数据类型
    来类比 [bool] 数据。并且使用 [B0] 和 [B1] 两种构造子来表示其可能的取值。
    最后定义 [nybble] 这种数据类型，也就是一个四比特的元组。*)

Inductive bit : Type :=
  | B1
  | B0.

Inductive nybble : Type :=
  | bits (b0 b1 b2 b3 : bit).

Check (bits B1 B0 B1 B0)
  : nybble.

(** 这里的 [bits] 构造子起到了对它内容的包装作用。
    解包可以通过模式匹配来实现，就如同下面的 [all_zero] 函数一样，
    其通过解包来验证一个半字节的所有比特是否都为 [B0]。 *)

Definition all_zero (nb : nybble) : bool :=
  match nb with
  | (bits B0 B0 B0 B0) => true
  | (bits _ _ _ _) => false
  end.

(** （我们用【通配符】 [_] 来避免创建不需要的变量名。） *)

Compute (all_zero (bits B1 B0 B1 B0)).
(* ===> false : bool *)
Compute (all_zero (bits B0 B0 B0 B0)).
(* ===> true : bool *)

End TuplePlayground.

(* ================================================================= *)
(** ** 自然数 *)

(** 我们将本节置于一个模块中，这样我们自己对【自然数|Natural Numbers】
    的定义就不会与【标准库|Standard Library】中的定义产生冲突。
    在本书的其余部分，我们将使用标准库中的定义。 *)

Module NatPlayground.

(** 目前我们定义的所有类型都是有限的。无论是像 [day], [bool] 和 [bit]
    这样的「枚举类型」，抑或是像 [nybble] 这样基于「枚举类型」的元组类型，
    本质上都是有限的集合。而【自然数|Natural Numbers】是一个无限集合，
    因此我们需要一种更强大的类型声明方式来表示它们。

    数字的表示方法有许多种。我们最为熟悉的便是十进制，利用
    0～9 十个数字来表示一个数，例如用 1、2 和 3 来表示数值 123。
    你或许也接触过十六进制，在十六进制中，它被表示为 7B。
    在八进制中为 173，二进制则为 111011。我们可以使用枚举类型
    来定义以上任何一种数字表示方式。它们在不同的场景下有着不同的用途。

    二进制表示在计算机硬件中起着举足轻重的作用。它只需要两种不同的电平
    来表示，因此它的硬件电路可以被设计得十分简单。同样，
    我们也希望选择一种自然数的表示方式，来让我们的【证明|Proof】变得更加简单。

    实际上，比起二进制，还有一种更加简单的数字表示方式，即【一进制|Unary】，
    也就是只使用单个数字的表示方式，就如同我们的祖先山顶洞人在墙上
    刻划痕计算日子一般。为了在 Rocq 中表示一进制数，我们使用两个构造子。
    大写的 [O] 构造子用来表示「零」，而大写的 [S] 构造子用来表示
    「【后继|Successor】」（或者洞穴上的「痕迹」）。当 [S]
    构造子被应用到一个自然数 n 的表示上时，结果会是自然数 [n+1] 的表示。
    下面是完整的数据类型定义。 *)

Inductive nat : Type :=
  | O
  | S (n : nat).

(** 在这种定义下， 0 被表示为 [O], 1 则被表示为 [S O],
    2 则是 [S (S O)]，以此类推。 *)

(** 非形式化地说，此定义中的子句可读作：
      - [O] 是一个自然数（注意这里是字母「[O]」，不是数字「[0]」）。
      - [S] 可被放在一个自然数之前来产生另一个自然数 ——
        也就是说，如果 [n] 是一个自然数，那么 [S n] 也是。 *)

(** 同样，我们来仔细观察这个定义。
    [nat] 的定义描述了集合 [nat] 中的表达式是如何构造的：

    - 构造子表达式 [O] 属于集合 [nat]；
    - 如果 [n] 是属于集合 [nat] 的构造子表达式，
      那么 [S n] 也是属于集合 [nat] 的构造子表达式；并且
    - 只有以这两种产生的方式构造的表达式才属于集合 [nat]。 *)

(** 这些条件精确刻画了我们给予 Rocq 的 [Inductive] 归纳声明。
    它们意味着，构造子表达式 [O]、[S O]、[S (S O)]、[S (S (S O))]
    等等都属于集合 [nat]，而其它的构造子表达式，如
    [true]、[andb true false]、[S (S false)] 以及 [O (O (O S))] 等则不属于 [nat]。

    关键之处在于，我们目前只是定义了一种数字的【表示】方式，
    即一种写下它们的方式。名称 [O] 和 [S] 是任意的，在这一点上它们没有特殊的意义，
    它们只是我们能用来写下数字的两个不同的记号（以及一个说明了任何 [nat]
    都能写成一串 [S] 后跟一个 [O] 的规则）。如果你喜欢，完全可以将同样的定义写成： *)

Inductive otherNat : Type :=
  | stop
  | tick (foo : otherNat).

(** 这些记号的【解释】完全取决于我们如何用它进行计算。 *)

(** 我们可以像之前的布尔值或日期那样，
    编写一个函数来对上述自然数的表示进行模式匹配。
    例如，以下为前趋函数：*)

Definition pred (n : nat) : nat :=
  match n with
  | O => O
  | S n' => n'
  end.

(** 第二个分支可以读作：「如果 [n] 对于某个 [n'] 的形式为 [S n']，
    那么就返回 [n']。」 *)

(** 下面的 [End] 指令会关闭当前的模块，
    所以 [nat] 会重新代表标准库中的类型而非我们自己定义的 [nat]。 *)

End NatPlayground.

(** 为了让自然数使用起来更加自然，Rocq 内建了一小部分解析打印功能：
    普通的十进制数可视为「一进制」自然数的另一种记法，以代替 [S] 与 [O] 构造子；
    反过来，Rocq 也会默认将自然数打印为十进制形式： *)

Check (S (S (S (S O)))).
(* ===> 4 : nat *)

Definition minustwo (n : nat) : nat :=
  match n with
  | O => O
  | S O => O
  | S (S n') => n'
  end.

Compute (minustwo 4).
(* ===> 2 : nat *)

(** 构造子 [S] 的类型为 [nat -> nat]，与 [pred] 和 [minustwo] 之类的函数相同： *)

Check S        : nat -> nat.
Check pred     : nat -> nat.
Check minustwo : nat -> nat.

(** 以上三个东西均可作用于自然数，并产生自然数结果，但第一个 [S]
    与后两者有本质区别：[pred] 和 [minustwo] 这类函数是通过给定的【计算规则】定义的——
    例如 [pred] 的定义表明 [pred 2] 可化简为 [1]——但 [S] 的定义不包含此类行为。
    虽然 [S] 可以作用于参数这点与函数【相似】，但其作用仅限于构造数字，而并不用于【做】任何计算。

    考虑标准的十进制数：数字 [1] 不代表任何计算，只表示一份数据。
    当我们写下 [111] 来表示数字一百一十一时，实际上是写了三个符号 [1] 来表示此数的各位。

    现在我们来为数值定义更多的函数。

    简单的模式匹配不足以描述很多有趣的数值运算，我们还需要递归定义。
    例如：给定自然数 [n]，欲判定其是否为偶数，则需递归检查 [n-2] 是否为偶数。
    此类函数可通过关键字 [Fixpoint] 而非 [Definition] 来引入。 *)

Fixpoint even (n:nat) : bool :=
  match n with
  | O        => true
  | S O      => false
  | S (S n') => even n'
  end.

(** 我们可以使用类似的 [Fixpoint] 声明来定义 [odd] 函数，
    不过还有种更简单方式：*)

Definition odd (n:nat) : bool :=
  negb (even n).

Example test_odd1:    odd 1 = true.
Proof. simpl. reflexivity.  Qed.
Example test_odd2:    odd 4 = false.
Proof. simpl. reflexivity.  Qed.

(** （如果你逐步检查完这些证明，就会发现 [simpl] 其实没什么作用
    —— 所有工作都被 [reflexivity] 完成了。我们之后会讨论为什么会这样。)

    当然，我们也可以用递归来定义多参函数。  *)

Module NatPlayground2.

Fixpoint plus (n : nat) (m : nat) : nat :=
  match n with
  | O => m
  | S n' => S (plus n' m)
  end.

(** 三加二等于五，不出所料。 *)

Compute (plus 3 2).
(* ===> 5 : nat *)

(** Rocq 所执行的化简步骤如下所示： *)

(*      [plus 3 2]
   i.e. [plus (S (S (S O))) (S (S O))]
    ==> [S (plus (S (S O)) (S (S O)))]
      （根据第二个 [match] 子句）
    ==> [S (S (plus (S O) (S (S O))))]
      （根据第二个 [match] 子句）
    ==> [S (S (S (plus O (S (S O)))))]
      （根据第二个 [match] 子句）
    ==> [S (S (S (S (S O))))]
      （根据第一个 [match] 子句）
   i.e. [5]  *)

(** 为了书写方便，如果两个或更多参数具有相同的类型，那么它们可以写在一起。
    在下面的定义中，[(n m : nat)] 的意思与 [(n : nat) (m : nat)] 相同。 *)

Fixpoint mult (n m : nat) : nat :=
  match n with
  | O => O
  | S n' => plus m (mult n' m)
  end.

Example test_mult1: (mult 3 3) = 9.
Proof. simpl. reflexivity.  Qed.

(** 你可以在两个表达式之间添加逗号来同时匹配它们：*)

Fixpoint minus (n m:nat) : nat :=
  match n, m with
  | O   , _    => O
  | S _ , O    => n
  | S n', S m' => minus n' m'
  end.

End NatPlayground2.

Fixpoint exp (base power : nat) : nat :=
  match power with
  | O => S O
  | S p => mult base (exp base p)
  end.

(** **** Exercise: 1 star, standard (factorial)

    回想一下标准的阶乘函数：

       factorial(0)  =  1
       factorial(n)  =  n * factorial(n-1)     (if n>0)

    把它翻译成 Rocq 代码。

    提示：确保你在提供的头信息和你的定义之间添加了 [:=]。
    如果看到类似 "The reference factorial was not found in the current environment,"
    的错误信息，这意味着你可能忘记了添加 [:=]。 *)

Fixpoint factorial (n:nat) : nat
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Example test_factorial1:          (factorial 3) = 6.
(* FILL IN HERE *) Admitted.
Example test_factorial2:          (factorial 5) = (mult 10 12).
(* FILL IN HERE *) Admitted.
(** [] *)

(** 同样，我们可以通过引入加法、乘法和减法的【记法|Notation】
    来让数字表达式更加易读。 *)

Notation "x + y" := (plus x y)
                       (at level 50, left associativity)
                       : nat_scope.
Notation "x - y" := (minus x y)
                       (at level 50, left associativity)
                       : nat_scope.
Notation "x * y" := (mult x y)
                       (at level 40, left associativity)
                       : nat_scope.

Check ((0 + 1) + 1) : nat.

(** （[level]、[associativity] 和 [nat_scope] 标记控制着 Rocq
    语法分析器如何处理上述记法。目前无需关注这些细节。有兴趣的读者可参阅本章末尾
    「关于记法的更多内容」一节。）

    注意，这些声明并不会改变我们之前的定义，而只是让 Rocq 语法分析器接受用
    [x + y] 来代替 [plus x y]，并在 Rocq 美化输出时反过来将 [plus x y]
    显示为 [x + y]。 *)

(** 当我们说 Rocq 几乎没有任何「内置」内容时，我们是认真的：
    甚至连【相等性测试|Testing Equality】都是一个【用户定义的操作|User-Defined Operation】！
    [eqb] 函数定义如下：该函数检验自然数 [nat] 间是否满足相等关系 [eq]，
    并以布尔值 [bool] 表示。注意该定义使用嵌套匹配 [match]
    （亦可仿照 [minus] 使用并列匹配）。 *)

Fixpoint eqb (n m : nat) : bool :=
  match n with
  | O => match m with
         | O => true
         | S m' => false
         end
  | S n' => match m with
            | O => false
            | S m' => eqb n' m'
            end
  end.

(** 类似地，[leb] 函数检验其第一个参数是否小于等于第二个参数，以布尔值表示。 *)

Fixpoint leb (n m : nat) : bool :=
  match n with
  | O => true
  | S n' =>
      match m with
      | O => false
      | S m' => leb n' m'
      end
  end.

Example test_leb1:                leb 2 2 = true.
Proof. simpl. reflexivity.  Qed.
Example test_leb2:                leb 2 4 = true.
Proof. simpl. reflexivity.  Qed.
Example test_leb3:                leb 4 2 = false.
Proof. simpl. reflexivity.  Qed.

(** 我们之后会经常用到它们（特别是 [eqb]），因此先定义好它们的中缀记法： *)

Notation "x =? y" := (eqb x y) (at level 70) : nat_scope.
Notation "x <=? y" := (leb x y) (at level 70) : nat_scope.

Example test_leb3': (4 <=? 2) = false.
Proof. simpl. reflexivity.  Qed.

(** 现在我们有两个看起来都像等号的符号：[=] 和 [=?]。
    稍后我们将详细讨论它们的异同。目前，主要需要注意的一点是：
    [x = y] 是一个逻辑上的【断言|Claim】，即一个我们可以尝试去证明的
    「【命题|Proposition】」；而 [x =? y] 则是一个我们可以计算其结果
    （[true] 或 [false]）的布尔【表达式|Expression】。 *)

(** **** Exercise: 1 star, standard (ltb)

    补完 [ltb] 函数的定义，它测试自然数间的小于（[l]ess-[t]han）关系，
    并以布尔值 [bool] 表示。

    提示：与其为此编写一个新的 [Fixpoint]，不如根据之前定义的函数来定义它，
    仅使用一个之前定义的函数即可完成。但如果你愿意，也可以使用两个。*)

Definition ltb (n m : nat) : bool
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Notation "x <? y" := (ltb x y) (at level 70) : nat_scope.

Example test_ltb1:             (ltb 2 2) = false.
(* FILL IN HERE *) Admitted.
Example test_ltb2:             (ltb 2 4) = true.
(* FILL IN HERE *) Admitted.
Example test_ltb3:             (ltb 4 2) = false.
(* FILL IN HERE *) Admitted.
(** [] *)

(* ################################################################# *)
(** * 基于化简的证明 *)

(** 至此，我们已经定义了一些数据类型和函数。让我们把问题转到如何表述和证明
    它们行为的性质上来。其实我们已经开始这样做了：前几节中的每个 [Example]
    都对几个函数在某些特定输入上的行为做出了准确的断言。这些断言的证明方法都一样：
    使用 [simpl] 来化简等式两边，然后用 [reflexivity] 来检查两边是否具有相同的值。

    这类「基于化简的证明」还可以用来证明更多有趣的性质。例如，对于“[0]
    出现在左边时是加法 [+] 的‘幺元’”这一事实，我们只需读一遍 [plus] 的定义，
    即可通过观察「对于 [0 + n]，无论 [n] 的值为多少均可化简为 [n]」而得到证明。 *)
Example plus_1_1 : 1 + 1 = 2.
Proof. simpl. reflexivity. Qed.

(** 同样这种「化简证明」也可以用来确立更多有趣的性质。
    例如，[0] 是 [+] 的左【单位元|Neutral Element】这一事实，
    只需观察到无论 [n] 是什么，[0 + n] 都会规约为 [n] 即可证明 ——
    这一事实可以直接从 [plus] 的定义中读出。 *)

Theorem plus_O_n : forall n : nat, 0 + n = n.
Proof.
  intros n. simpl. reflexivity.  Qed.

(** （或许你会注意到以上语句在你的 IDE 中和在浏览器渲染的 HTML
    中不大一样，我们用保留标识符「forall」来表示全称量词
    [forall]。当 [.v] 文件转换为 HTML 后，它会变成一个倒立的「A」。）

    现在是时候说一下 [reflexivity] 了，它其实比我们想象的更为强大。
    在前面的例子中，其实并不需要调用 [simpl] ，因为 [reflexivity]
    在检查等式两边是否相等时会自动做一些化简；我们加上 [simpl] 只是为了看到化简之后，
    证明结束之前的中间状态。下面是对同一定理更短的证明：*)

Theorem plus_O_n' : forall n : nat, 0 + n = n.
Proof.
  intros n. reflexivity. Qed.

(** 此外，[reflexivity] 在某些方面做了比 [simpl] 【更多】的化简 ——
    比如它会尝试「展开」已定义的项，将它们替换为该定义右侧的值。
    了解这一点会很有帮助。产生这种差别的原因是，当自反性成立时，
    整个证明目标就完成了，我们不必再关心 [reflexivity] 化简和展开了什么；
    而当我们必须去观察和理解新产生的证明目标时，我们并不希望盲目地展开定义，
    将证明目标留在混乱的声明中。这种情况下就要用到 [simpl] 了。

    我们刚刚声明的定理形式及其证明与前面的例子基本相同，它们只有一点差别。

    首先，我们使用了关键字 [Theorem] 而非 [Example]。这种差别纯粹是风格问题；
    在 Rocq 中，关键字 [Example] 和 [Theorem]（以及其它一些，包括 [Lemma]、[Fact]
    和 [Remark]）都表示完全一样的东西。

    其次，我们增加了量词 [forall n:nat]，因此我们的定理讨论了【所有的】 自然数 [n]。
    在非形式化的证明中，为了证明这种形式的定理，我们通常会说“【假设】
    存在一个任意自然数 [n]...”。而在形式化证明中，这是用 [intros n]
    来实现的，它会将量词从证明目标转移到当前假设的【语境|Context】中。

    注意在 [intros] 从句中，我们可以使用别的标识符来代替 [n]
    （当然这可能会让阅读证明的人感到困惑）： *)

Theorem plus_O_n'' : forall n : nat, 0 + n = n.
Proof.
  intros m. reflexivity. Qed.

(** 关键字 [intros]、[simpl] 和 [reflexivity] 都是【策略|Tactic】的例子。
    策略是一条可以用在【[Proof]|证明】和【[Qed]|证毕】之间的指令，它告诉 Rocq
    如何来检验我们所下的一些断言的正确性。在本章剩余的部分及以后的课程中，
    我们会见到更多的策略。 *)

(** 其它类似的定理可通过相同的模式证明。 *)

Theorem plus_1_l : forall n:nat, 1 + n = S n.
Proof.
  intros n. reflexivity.  Qed.

Theorem mult_0_l : forall n:nat, 0 * n = 0.
Proof.
  intros n. reflexivity.  Qed.

(** 上述定理名称的后缀 [_l] 读作「在左边」。 *)

(** 跟进这些证明的每个步骤，观察语境及证明目标的变化是非常值得的。
    你可能要在 [reflexivity] 前面加上 [simpl] 调用，以便观察 Rocq
    在检查它们的相等关系前进行的化简。 *)

(* ################################################################# *)
(** * 基于改写的证明 *)

(** 下面这个定理比我们之前见过的更加有趣： *)

Theorem plus_id_example : forall n m:nat,
  n = m ->
  n + n = m + m.

(** 该定理并未对自然数 [n] 和 [m] 所有可能的值做全称断言，而是讨论了仅当
    [n = m] 时这一更加特定情况。箭头符号读作「【蕴含|Implies】」。

    与此前相同，我们需要在能够假定存在自然数 [n] 和 [m] 的基础上进行推理。
    另外我们需要假定有前提 [n = m]。[intros] 策略用来将这三条前提从证明目标
    移到当前语境的假设中。

    由于 [n] 和 [m] 是任意自然数，我们无法用化简来证明此定理，
    不过可以通过观察来证明它。如果我们假设了 [n = m]，那么就可以将证明目标中的
    [n] 替换成 [m] 从而获得两边表达式相同的等式。用来告诉 Rocq
    执行这种替换的策略叫做【改写】 [rewrite]。 *)

Proof.
  (* 将两个量词移到语境中： *)
  intros n m.
  (* 将前提移到语境中： *)
  intros H.
  (* 用前提改写目标： *)
  rewrite -> H.
  reflexivity.  Qed.

(** 证明的第一行将全称量词变量 [n] 和 [m] 移到语境中。第二行将前提
    [n = m] 移到语境中，并将其命名为 [H]。第三行告诉 Rocq
    改写当前目标（[n + n = m + m]），把前提等式 [H] 的左边替换成右边。

    ([rewrite] 中的箭头与蕴含无关：它指示 Rocq 从左往右地应用改写。
    若要从右往左改写，可以使用 [rewrite <-]。在上面的证明中试一试这种改变，
    看看 Rocq 的反应有何不同。) *)
(** **** Exercise: 1 star, standard (plus_id_exercise) *)

(** 删除 "[Admitted.]" 并补完证明。（注意该定理有【两个】假设：[n = m]
    和 [m = o]，它们都位于蕴含箭头的左侧。） *)

Theorem plus_id_exercise : forall n m o : nat,
  n = m -> m = o -> n + m = m + o.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** [Admitted] 指令告诉 Rocq 我们想要跳过此定理的证明，而将其作为已知条件，
    这在开发较长的证明时很有用。在进行一些较大的命题论证时，我们能够声明一些附加的事实。
    既然我们认为这些事实对论证是有用的，就可以用 [Admitted] 先不加怀疑地接受这些事实，
    然后继续思考大命题的论证。直到确认了该命题确实是有意义的，
    再回过头去证明刚才跳过的证明。

    但是要小心：每次你使用 [Admitted]，你就为 Rocq 这个完好、严密、
    形式化且封闭的世界开了一个毫无逻辑的后门。 *)

(** [Check] 命令也可用来检查以前声明的引理和定理。下面两个关于乘法的引理来自于标准库。
    （在下一章中，我们会亲自证明它们。） *)

Check mult_n_O.
(* ===> forall n : nat, 0 = n * 0 *)

Check mult_n_Sm.
(* ===> forall n m : nat, n * m + n = n * S m *)

(** 除了语境中现有的假设外，我们还可以通过 [rewrite] 策略来运用前期证明过的定理。
    如果前期证明的定理的语句中包含量词变量，如前例所示，
    Rocq 会尝试通过将先前定理陈述的正文与当前目标进行匹配，
    来为它们填入适当的值。 *)

Theorem mult_n_0_m_0 : forall p q : nat,
  (p * 0) + (q * 0) = 0.
Proof.
  intros p q.
  rewrite <- mult_n_O.
  rewrite <- mult_n_O.
  reflexivity. Qed.

(** **** Exercise: 1 star, standard (mult_n_1)

    使用 [mult_n_Sm] 和 [mult_n_O] 来证明以下定理。
    （回想一下，[1] 即 [S O]。） *)

Theorem mult_n_1 : forall p : nat,
  p * 1 = p.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(* ################################################################# *)
(** * 利用情况分析来证明 *)

(** 当然，并非一切都能通过简单的计算和改写来证明。通常，一些未知的，
    假定的值（如任意数值、布尔值、列表等等）会阻碍化简。
    例如，如果我们像以前一样使用 [simpl] 策略尝试证明下面的事实，就会被卡住。
    （现在我们用 [Abort] 指令来放弃证明。） *)

Theorem plus_1_neq_0_firsttry : forall n : nat,
  (n + 1) =? 0 = false.
Proof.
  intros n.
  simpl.  (* does nothing! *)
Abort.

(** 原因在于：根据 [eqb] 和 [+] 的定义，其第一个参数先被 [match] 匹配。
    但此处 [+] 的第一个参数 [n] 未知，而 [eqb] 的第一个参数 [n + 1]
    是复合表达式，二者均无法化简。

    欲进行规约，则需分情况讨论 [n] 的所有可能构造。如果 [n] 为 [O]，
    则可验算 [(n + 1) =? 0] 的结果确实为 [false]；如果 [n] 由 [S n'] 构造，
    那么即使我们不知道 [n + 1] 表示什么，但至少知道它的构造子为 [S]，
    因而足以得出 [(n + 1) =? 0] 的结果为 [false]。

    告诉 Rocq 分别对 [n = 0] 和 [n = S n'] 这两种情况进行分析的策略，叫做 [destruct]。 *)

Theorem plus_1_neq_0 : forall n : nat,
  (n + 1) =? 0 = false.
Proof.
  intros n. destruct n as [| n'] eqn:E.
  - reflexivity.
  - reflexivity.   Qed.

(** [destruct] 策略会生成_两个_子目标，为了让 Rocq 认可这个定理，
    我们必须接下来证明这两个子目标。

    [as [| n']] 这种标注被称为【引入模式|Intro Pattern】。
    它告诉 Rocq 应当在每个子目标中使用什么样的变量名。总体而言，
    在方括号之间的是一个由 [|] 隔开的【列表的列表|list of lists】。
    在上面的例子中，第一个元素是一个空列表，因为 [O] 构造子是一个空构造子（它没有任何参数）。
    第二个元素提供了包含单个变量名 [n'] 的列表，因为 [S] 是一个单构造子。

    在每个子目标中，Rocq 会记录这个子目标中关于 [n] 的假设，[n = 0] 或者
    对于某个 n', [n = S n']。而 [eqn:E] 记号则告知 Rocq 以 [E] 来命名这些
    假设。（省略 [eqn:E] 会导致 Rocq 省略这些假设。这种省略能够使得一些不需要
    显式用到这类假设的证明显得更加流畅。但在实践中最好还是保留他们，
    因为他们可以作为一种说明文档来在证明过程中指引你。）

    第二行和第三行中的 [-] 符号叫做【标号|Bullet】，它标明了这两个生成的子目标所对应的证明部分。
    （译注：此处的「标号」应理解为一个项目列表中每个【条目|Item】前的小标记，如 ‣ 或 •。）
    标号后面的证明脚本是一个子目标的完整证明。在本例中，每个子目标都简单地使用
    [reflexivity] 完成了证明。通常，[reflexivity] 本身会执行一些化简操作。
    例如，第二段证明将 [at (S n' + 1) 0] 化简成 [false]，是通过先将
    [(S n' + 1)] 转写成 [S (n' + 1)]，接着展开 [beq_nat]，之后再化简 [match] 完成的。

    用标号来区分情况是可选的：如果没有标号，Rocq 只会简单地要求你依次证明每个子目标。
    尽管如此，使用标号仍然是一个好习惯。原因有二：首先，它能让证明的结构更加清晰易读。
    其次，标号能指示 Rocq 在开始验证下一个目标前确认上一个子目标已完成，
    防止不同子目标的证明搅和在一起。这一点在大型开发中尤为重要，
    因为一些证明片段会导致很耗时的排错过程。

    在 Rocq 中并没有既严格又便捷的规则来格式化证明 —— 尤其指应在哪里断行，
    以及证明中的段落应如何缩进以显示其嵌套结构。然而，无论格式的其它方面如何布局，
    只要在多个子目标生成的地方为每行开头标上标号，那么整个证明就会有很好的可读性。

    这里也有必要提一下关于每行代码长度的建议。Rocq 的初学者有时爱走极端，
    要么一行只有一个策略语句，要么把整个证明都写在一行里。更好的风格则介于两者之间。
    一个合理的习惯是给自己设定一个每行 80 个字符的限制（如果你有一个宽屏或好的视力，
    可以考虑 120 个字符）。更长的行会很难读，也不便于显示或打印。很多编辑器都能帮你做到。

    [destruct] 策略可用于任何归纳定义的数据类型。比如，我们接下来会用它来证明
    布尔值的取反是【对合|Involutive】的 —— 即，取反是自身的逆运算。 *)

Theorem negb_involutive : forall b : bool,
  negb (negb b) = b.
Proof.
  intros b. destruct b eqn:E.
  - reflexivity.
  - reflexivity.  Qed.

(** 注意这里的 [destruct] 没有 [as] 子句，因为此处 [destruct]
    生成的子分类均无需绑定任何变量，因此也就不必指定名字。
    实际上，我们也可以省略 【任何】 [destruct] 中的 [as] 子句，
    Rocq 会自动填上变量名。不过这通常是个坏习惯，因为如果任其自由决定的话，
    Rocq 经常会选择一些容易令人混淆的名字。

    有时在一个子目标内调用 [destruct]，产生出更多的证明义务（Proof Obligation）
    也非常有用。这时候，我们使用不同的标号来标记目标的不同「层级」，比如： *)

Theorem andb_commutative : forall b c, andb b c = andb c b.
Proof.
  intros b c. destruct b eqn:Eb.
  - destruct c eqn:Ec.
    + reflexivity.
    + reflexivity.
  - destruct c eqn:Ec.
    + reflexivity.
    + reflexivity.
Qed.

(** 每一对 [reflexivity] 调用和紧邻其上的 [destruct]
    执行后生成的子目标对应。 *)

(** 除了 [-] 和 [+] 之外，还可以使用 [*]（星号）或任何重复的标号符（如
    [--] 或 [***]）作为标号。我们也可以用花括号将每个子证明目标括起来： *)

Theorem andb_commutative' : forall b c, andb b c = andb c b.
Proof.
  intros b c. destruct b eqn:Eb.
  { destruct c eqn:Ec.
    { reflexivity. }
    { reflexivity. } }
  { destruct c eqn:Ec.
    { reflexivity. }
    { reflexivity. } }
Qed.

(** 由于花括号同时标识了证明的开始和结束，因此它们可以同时用于不同的子目标层级，
    如上例所示。此外，花括号还允许我们在一个证明中的多个层级下使用同一个标号。

    使用大括号、标号还是二者结合都纯粹是个人偏好问题。 *)

Theorem andb3_exchange :
  forall b c d, andb (andb b c) d = andb (andb b d) c.
Proof.
  intros b c d. destruct b eqn:Eb.
  - destruct c eqn:Ec.
    { destruct d eqn:Ed.
      - reflexivity.
      - reflexivity. }
    { destruct d eqn:Ed.
      - reflexivity.
      - reflexivity. }
  - destruct c eqn:Ec.
    { destruct d eqn:Ed.
      - reflexivity.
      - reflexivity. }
    { destruct d eqn:Ed.
      - reflexivity.
      - reflexivity. }
Qed.

(** **** Exercise: 2 stars, standard (andb_true_elim2)

    证明以下断言，在使用 [destruct] 时，请使用【标号|Bullet】来标记情况（及子情况）。

    提示 1：到目前为止，我们只使用过 [simpl] 来化简目标。
    实际上也可以用它来化简假设：使用 [simpl in H]（其中 [H] 为一个假设）即可。
    在本练习中你可能会发现这很有用。

    提示 2：你最终需要像上面的定理那样对两个布尔值都进行 destruct。
    在尝试对第二个布尔值进行 destruct 之前，最好先化简假设。

    提示 3：如果你在假设中遇到了矛盾，请专注于如何利用该矛盾进行 [rewrite]。 *)

Theorem andb_true_elim2 : forall b c : bool,
  andb b c = true -> c = true.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** 在本章结束之前，我们最后再说一种简便写法。或许你已经注意到了，
    很多证明在引入变量之后会立即对它进行情况分析：

       intros x y. destruct y as [|y] eqn:E.

    这种写法是如此的常见以至于 Rocq 为它提供了一种简写：我们可以在引入
    一个变量的同时对他使用【引入模式|Intro Pattern】来进行情况分析。
    例如，下面是一个对 [plus_1_neq_0] 的更简短证明。
    （这种简写的缺点也显而易见，我们无法再记录在每个子目标中所使用的假设，
    而之前我们可以通过 [eqn:E] 将它们标注出来。） *)

Theorem plus_1_neq_0' : forall n : nat,
  (n + 1) =? 0 = false.
Proof.
  intros [|n].
  - reflexivity.
  - reflexivity.  Qed.

(** 如果没有需要命名的构造子参数，我们只需写上 [[]] 即可进行情况分析。 *)

Theorem andb_commutative'' :
  forall b c, andb b c = andb c b.
Proof.
  intros [] [].
  - reflexivity.
  - reflexivity.
  - reflexivity.
  - reflexivity.
Qed.

(** **** Exercise: 1 star, standard (zero_nbeq_plus_1) *)
Theorem zero_nbeq_plus_1 : forall n : nat,
  0 =? (n + 1) = false.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(* ################################################################# *)
(** * 关于记法的更多内容 (可选) *)

(** （通常，标为可选的部分对于跟进本书其它部分的学习来说不是必须的，
    除了那些也标记为可选的部分。在初次阅读时，你可以快速浏览这些部分，
    以便在将来遇到时能够想起来这里讲了些什么。）

    回忆一下中缀加法和乘法的记法定义：*)

Notation "x + y" := (plus x y)
                       (at level 50, left associativity)
                       : nat_scope.
Notation "x * y" := (mult x y)
                       (at level 40, left associativity)
                       : nat_scope.

(** 对于 Rocq 中的每个记法符号，我们可以指定它的【优先级|Precedence Level】
    和【结合性|Associativity】。优先级 [n] 用 [at level n] 来表示，
    这样有助于 Rocq 分析复合表达式。
    结合性的设置有助于消除表达式中相同符号出现多次时产生的歧义。比如，
    上面这组对 [+] 和 [*] 的参数定义的表达式 [1+2*3*4] 是 [(1+((2*3)*4))] 的
    简写。Rocq 使用 0 到 100 的优先级等级，同时支持【左结合】、【右结合】
    和【不结合】三种结合性。之后我们在别的章节会看到更多与此相关的例子，比如
    [Lists] 一章。

    每个记法符号还与 【记法范围|Notation Scope】相关。Rocq 会尝试根据语境来猜测
    你所指的范围，因此当你写出 [S(0*0)] 时，它猜测是 [nat_scope]；而当你
    写出积（元组）类型 [bool*bool] 时，它猜测是 [type_scope]。
    有时你可能必须百分号记法 [(x*y)%nat] 来帮助 Rocq 确定范围。
    另外，有时 Rocq 打印的结果中也用 [%nat] 来指示记法所在的范围。

    记法范围同样适用于数值记法（[3]、[4]、[5]、[42] 等等），因此你有时候会看到
    [0%nat]，表示 [0]（即我们在本章中使用的自然数零 [0]），而 [0%Z] 表示整数零
    （来自于标准库中的另一个部分）。

    专业提示：Rocq 的符号机制不是特别强大，别期望太多。 *)

(* ################################################################# *)
(** * 不动点 [Fixpoint] 和结构化递归 (可选) *)

(** 以下是加法定义的一个副本： *)

Fixpoint plus' (n : nat) (m : nat) : nat :=
  match n with
  | O => m
  | S n' => S (plus' n' m)
  end.

(** 当 Rocq 查看此定义时，它会注意到「[plus'] 的第一个参数是递减的」。
    这意味着我们对参数 [n] 执行了【结构化递归】。换言之，我们仅对严格递减的
    [n] 值进行递归调用。这一点蕴含了「对 [plus'] 的调用最终会停止」。
    Rocq 要求每个 [Fixpoint] 定义中的某些参数必须是「递减的」。

    这项要求是 Rocq 的基本特性之一，它保证了 Rocq 中定义的所有函数对于所有输入都会终止。
    然而，由于 Rocq 的「递减分析」不是非常精致，
    因此有时必须用一点不同寻常的方式来编写函数。 *)

(** **** Exercise: 2 stars, standard, optional (decreasing)

    为了更好的理解这一点，请尝试写一个对于所有输入都_确定_终止的 [Fixpoint]
    定义。但这个定义需要违背上述的限制，以此来让 Rocq 拒绝。

    （如果您决定将这个可选的练习作为作业提交，请确保将您的解答注释掉以防止
    Rocq 拒绝执行整个文件。） *)

(* FILL IN HERE

    [] *)

(* ################################################################# *)
(** * 更多练习 *)

(* ================================================================= *)
(** ** 热身 *)

(** **** Exercise: 1 star, standard (identity_fn_applied_twice)

    用你学过的策略证明以下关于布尔函数的定理。 *)

Theorem identity_fn_applied_twice :
  forall (f : bool -> bool),
  (forall (x : bool), f x = x) ->
  forall (b : bool), f (f b) = b.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(** **** Exercise: 1 star, standard (negation_fn_applied_twice)

    现在声明并证明定理 [negation_fn_applied_twice]，与上一个类似，
    但是第二个前提说明函数 [f] 有 [f x = negb x] 的性质。 *)

(* FILL IN HERE *)

(* Do not modify the following line: *)
Definition manual_grade_for_negation_fn_applied_twice : option (nat*string) := None.
(** （最后一个定义会用于自动评分器）

    [] *)

(** **** Exercise: 3 stars, standard, optional (andb_eq_orb)

    证明以下定理。提示：这可能有点棘手，
    你需要同时使用 [destruct] 和 [rewrite]，
    但一次结构所有的内容并不是最好的方式。 *)

Theorem andb_eq_orb :
  forall (b c : bool),
  (andb b c = orb b c) ->
  b = c.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(* ================================================================= *)
(** ** 课程迟交政策，形式化 *)

(** 假设某门课程有一套基于迟交天数的评分政策：
    如果学生有太多的作业迟交，其最终的等级成绩就会被降低。

    在接下来的系列问题中，我们将利用目前见过的 Rocq 特性来对这种情况进行
    建模，并证明一些关于该评分政策的简单事实。 *)

Module LateDays.

(** 首先，我们引入一个数据类型来对成绩中的「等级」部分进行建模。 *)
Inductive letter : Type :=
  | A | B | C | D | F.

(** 接着我们定义修饰符—— [Natural] [A] 指的就是「平常」的 [A] 级成绩。 *)
Inductive modifier : Type :=
  | Plus | Natural | Minus.

(** 那么，一个完整的成绩 [grade] 就只是由一个等级 [letter] 和一个
    修饰符 [modifier] 组成的。

    非正式地说，我们可以将 Rocq 中的值 [Grade A Minus] 写成「A-」，
    同样地，将 Rocq 中的值 [Grade C Natural] 写成「C」。 *)
Inductive grade : Type :=
  Grade (l:letter) (m:modifier).

(** 我们希望能够表达某个成绩何时比另一个「更好」。换言之，
    我们需要一种比较两个成绩的方法。与自然数的情形一样，
    我们可以定义返回 [bool] 值的函数 [grade_eqb]、[grade_ltb] 等，
    这样也完全可行。不过，我们也可以如下所示，定义一个稍微更富有信息量的类型
    来比较两个值。这个数据类型有三个构造子，分别用于表示两个值是否
    「相等」「小于」或「大于」对方。（这一定义同样出现在 Rocq 标准库中。）  *)

Inductive comparison : Type :=
  | Eq         (* "equal" *)
  | Lt         (* "less than" *)
  | Gt.        (* "greater than" *)

(** 使用模式匹配，不难定义对两个等级字母 [l1] 和 [l2] 进行比较的运算
    （见下文）。这个定义用到了 [match] 模式的两个特性：首先，
    回忆一下，我们可以用逗号 [,] 分隔两个值及其对应的模式，
    从而同时对_两个_值进行匹配。这只是嵌套模式匹配的一种方便的简写形式。
    例如，下面左侧的 match 表达式只不过是右侧更底层的「展开版本」的简写：

  match l1, l2 with          match l1 with
  | A, A => Eq               | A => match l2 with
  | A, _ => Gt                      | A => Eq
  end                               | _ => Gt
                                    end
                             end
*)
(** 另一种简写是，我们也可以在模式中使用 [|] 来匹配若干可能性之一。
    例如，模式 [C , (A | B)] 代表两种情况：[C, A] 和 [C, B]。 *)

Definition letter_comparison (l1 l2 : letter) : comparison :=
  match l1, l2 with
  | A, A => Eq
  | A, _ => Gt
  | B, A => Lt
  | B, B => Eq
  | B, _ => Gt
  | C, (A | B) => Lt
  | C, C => Eq
  | C, _ => Gt
  | D, (A | B | C) => Lt
  | D, D => Eq
  | D, _ => Gt
  | F, (A | B | C | D) => Lt
  | F, F => Eq
  end.

(** 我们可以通过在一些例子上测试 [letter_comparison] 运算来进行验证。 *)
Compute letter_comparison B A.
(** ==> Lt *)
Compute letter_comparison D D.
(** ==> Eq *)
Compute letter_comparison B F.
(** ==> Gt *)

(** 作为进一步的【健全性检查|Sanity Check】，我们可以证明，当把字母 [l] 与它自身进行比较时，
    [letter_comparison] 函数确实会给出结果 [Eq]。 *)
(** **** Exercise: 1 star, standard (letter_comparison) *)
Theorem letter_comparison_Eq :
  forall l, letter_comparison l l = Eq.
Proof.
  (* FILL IN HERE *) Admitted.
(** [] *)

(** 我们可以采用相同的策略来定义两个成绩【修饰符|Modifier】之间的比较运算。
    我们认为它们的顺序为 [Plus > Natural > Minus]。 *)
Definition modifier_comparison (m1 m2 : modifier) : comparison :=
  match m1, m2 with
  | Plus, Plus => Eq
  | Plus, _ => Gt
  | Natural, Plus => Lt
  | Natural, Natural => Eq
  | Natural, _ => Gt
  | Minus, (Plus | Natural) => Lt
  | Minus, Minus => Eq
  end.

(** **** Exercise: 2 stars, standard (grade_comparison)

    使用模式匹配来完成以下定义。

    （这种成绩的排序有时被称为「字典序（lexicographic）」
    排序：我们首先比较字母，只有在字母相等的情况下才考虑
    修饰符。也就是说，[A] 的所有成绩变体都大于 [B] 的所有成绩变体。）

    提示：同时对 [g1] 和 [g2] 进行匹配，但不要尝试枚举所有情况。
    相反，对适当调用 [letter_comparison] 的结果进行情况分析，
    从而最终只需处理 [3] 种可能性。 *)

Definition grade_comparison (g1 g2 : grade) : comparison
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

(** 一旦你正确地定义了 [grade_comparison] 函数，以下对该函数的
    「单元测试」应当能够顺利通过。 *)

Example test_grade_comparison1 :
  (grade_comparison (Grade A Minus) (Grade B Plus)) = Gt.
(* FILL IN HERE *) Admitted.

Example test_grade_comparison2 :
  (grade_comparison (Grade A Minus) (Grade A Plus)) = Lt.
(* FILL IN HERE *) Admitted.

Example test_grade_comparison3 :
  (grade_comparison (Grade F Plus) (Grade F Plus)) = Eq.
(* FILL IN HERE *) Admitted.

Example test_grade_comparison4 :
  (grade_comparison (Grade B Minus) (Grade C Plus)) = Gt.
(* FILL IN HERE *) Admitted.

(** [] *)

(** 既然我们已经有了成绩的定义以及它们如何进行互相比较，
    现在让我们来实现一个【迟交惩罚|late-penalty】函数。 *)

(** 首先，我们定义什么叫做降低成绩中的等级字母 [letter] 部分。
    由于 [F] 已经是最低的可能等级，因此我们对其保持不变。 *)
Definition lower_letter (l : letter) : letter :=
  match l with
  | A => B
  | B => C
  | C => D
  | D => F
  | F => F  (* Can't go lower than [F]! *)
  end.

(** 我们的形式化工作已经可以帮助我们理解评分政策中的一些边界情况。
    例如，我们可能会期望，如果使用 [lower_letter] 函数，其结果确实会更低，
    正如以下定理所声称的那样。但这个定理是无法证明的！（你想通为什么了吗？） *)
Theorem lower_letter_lowers: forall (l : letter),
  letter_comparison (lower_letter l) l = Lt.
Proof.
  intros l.
  destruct l.
  - simpl. reflexivity.
  - simpl. reflexivity.
  - simpl. reflexivity.
  - simpl. reflexivity.
  - simpl. (* We get stuck here. *)
Abort.

(** 这个问题当然与降低 [F] 的「边界情况」有关，正如我们看到的那样： *)
Theorem lower_letter_F_is_F:
  lower_letter F = F.
Proof.
  simpl. reflexivity.
Qed.

(** 有了这一认识，我们可以声明一个更好的、确实可证的降级字母定理版本。
    在这个版本中，关于 [F] 的假设说明了 [F] 严格小于 [l]，
    这就排除了上面有问题的边界情况。换句话说，只要 [l] 比 [F] 大，
    它就一定会被降低。 *)
(** **** Exercise: 2 stars, standard (lower_letter_lowers)

    证明以下定理。 *)

Theorem lower_letter_lowers:
  forall (l : letter),
    letter_comparison F l = Lt ->
    letter_comparison (lower_letter l) l = Lt.
Proof.
(* FILL IN HERE *) Admitted.

(** [] *)

(** **** Exercise: 2 stars, standard (lower_grade)

    我们现在可以使用 [lower_letter] 定义作为辅助，来定义将成绩降低一步
    是什么意思。完成下面的定义，使其能将成绩 [g] 降低一步
    （除非它已经为 [Grade F Minus]，此时应当保持不变）。
    一旦你正确地实现了它，随后的「单元测试」示例应当显而易见地成立。

    提示：为了使这个定义足够简洁且易于证明其性质，你可能需要使用嵌套模式匹配。
    外层 match 不应该对成绩的具体字母部分进行匹配 —— 它应当只考虑修饰符。
    你绝对_不_应该尝试枚举所有可能的情况。

    我们的解决方案总共不到 10 行代码。 *)
Definition lower_grade (g : grade) : grade
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Example lower_grade_A_Plus :
  lower_grade (Grade A Plus) = (Grade A Natural).
Proof.
(* FILL IN HERE *) Admitted.

Example lower_grade_A_Natural :
  lower_grade (Grade A Natural) = (Grade A Minus).
Proof.
(* FILL IN HERE *) Admitted.

Example lower_grade_A_Minus :
  lower_grade (Grade A Minus) = (Grade B Plus).
Proof.
(* FILL IN HERE *) Admitted.

Example lower_grade_B_Plus :
  lower_grade (Grade B Plus) = (Grade B Natural).
Proof.
(* FILL IN HERE *) Admitted.

Example lower_grade_F_Natural :
  lower_grade (Grade F Natural) = (Grade F Minus).
Proof.
(* FILL IN HERE *) Admitted.

Example lower_grade_twice :
  lower_grade (lower_grade (Grade B Minus)) = (Grade C Natural).
Proof.
(* FILL IN HERE *) Admitted.

Example lower_grade_thrice :
  lower_grade (lower_grade (lower_grade (Grade B Minus))) = (Grade C Minus).
Proof.
(* FILL IN HERE *) Admitted.

(** Rocq 对 [Example] 和 [Theorem] 并不做区分。我们将以下内容声明为 [Theorem]，
    仅仅是为了提示我们会在下面的证明中用到它。 *)
Theorem lower_grade_F_Minus : lower_grade (Grade F Minus) = (Grade F Minus).
Proof.
(* FILL IN HERE *) Admitted.

(* GRADE_THEOREM 0.25: lower_grade_A_Plus *)
(* GRADE_THEOREM 0.25: lower_grade_A_Natural *)
(* GRADE_THEOREM 0.25: lower_grade_A_Minus *)
(* GRADE_THEOREM 0.25: lower_grade_B_Plus *)
(* GRADE_THEOREM 0.25: lower_grade_F_Natural *)
(* GRADE_THEOREM 0.25: lower_grade_twice *)
(* GRADE_THEOREM 0.25: lower_grade_thrice *)
(* GRADE_THEOREM 0.25: lower_grade_F_Minus

    [] *)

(** **** Exercise: 3 stars, standard (lower_grade_lowers)

    证明以下定理，它指出只要成绩的起始级别高于 F-，使用 [lower_grade] 确实会降低成绩。
    和往常一样，把眼前能看到的所有东西都进行 destruct 并_不是_一个好主意。
    明智地结合使用 [destruct] 和重写（rewriting）是更好的策略。

    提示：如果你按照建议定义了 [grade_comparison] 函数，
    那么你只需要在一种情况下对 [letter] 进行 destruct。
    处理 [F] 的情况可能会受益于 [lower_grade_F_Minus]。
  *)
Theorem lower_grade_lowers :
  forall (g : grade),
    grade_comparison (Grade F Minus) g = Lt ->
    grade_comparison (lower_grade g) g = Lt.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(** 既然我们已经实现并测试了将成绩降低一步的函数，我们就可以实现一个具体的迟交天数政策。
    给定迟交天数 [late_days]，[apply_late_policy] 函数会根据初始成绩 [g] 计算最终成绩。

    该函数编码了以下政策：

      # 迟交天数      惩罚
         0 - 8        无惩罚
         9 - 16       降低成绩一步（A+ => A, A => A-, A- => B+，等等）
        17 - 20       降低成绩两步
          >= 21       降低成绩三步（相当于降低一个完整的等级字母）
*)
Definition apply_late_policy (late_days : nat) (g : grade) : grade :=
  if late_days <? 9 then g
  else if late_days <? 17 then lower_grade g
  else if late_days <? 21 then lower_grade (lower_grade g)
  else lower_grade (lower_grade (lower_grade g)).

(** 有时，「【展开|unfold】」一个定义对于推动证明的进展非常有用。
    我们很快就会看到如何以一种更简单的自动化方式来做到这一点，
    但就目前而言，仅通过使用 [reflexivity] 很容易证明：
    对任何像 [apply_late_policy] 这样的定义的调用，都等于其右侧的函数体。

    这个结果很有用，因为它允许我们使用 [rewrite] 来展示该定义的内部细节。 *)
Theorem apply_late_policy_unfold :
  forall (late_days : nat) (g : grade),
    (apply_late_policy late_days g)
    =
    (if late_days <? 9 then g  else
       if late_days <? 17 then lower_grade g
       else if late_days <? 21 then lower_grade (lower_grade g)
            else lower_grade (lower_grade (lower_grade g))).
Proof.
  intros. reflexivity.
Qed.

(** 现在让我们来证明关于该政策的一些性质。 *)

(** 下一个定理指出，如果学生在整个学期中累积的迟交天数不超过八天，
    他们的成绩就不会受到影响。这很容易证明：一旦你使用了
    [apply_late_policy_unfold]，你就可以利用假设来进行重写。 *)

(** **** Exercise: 2 stars, standard (no_penalty_for_mostly_on_time) *)
Theorem no_penalty_for_mostly_on_time :
  forall (late_days : nat) (g : grade),
    (late_days <? 9 = true) ->
    apply_late_policy late_days g = g.
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)

(** 以下定理指出，如果学生的迟交天数在 9 到 16 天之间，
    他们的最终成绩将被降低一步。 *)

(** **** Exercise: 2 stars, standard (graded_lowered_once) *)
Theorem grade_lowered_once :
  forall (late_days : nat) (g : grade),
    (late_days <? 9 = false) ->
    (late_days <? 17 = true) ->
    (apply_late_policy late_days g) = (lower_grade g).
Proof.
  (* FILL IN HERE *) Admitted.

(** [] *)
End LateDays.

(* ================================================================= *)
(** ** 二进制数 *)

(** **** Exercise: 3 stars, standard (binary)

    我们可以将对于自然数的一进制表示推广成更高效的二进制数表达方式。
    对于一个二进制数，我们可以将它看成一个由 [A0] 构造子和 [B1] 构造子
    组成的序列（它们分别表示 0 和 1），而这个序列的结束符为 [Z]。
    类似的，一个数的一进制表示可以看成一个由 [S] 构造子组成，并由 [O]
    构造子结束的序列。

    例如：

        decimal               binary                          unary
           0                       Z                              O
           1                    B1 Z                            S O
           2                B0 (B1 Z)                        S (S O)
           3                B1 (B1 Z)                     S (S (S O))
           4            B0 (B0 (B1 Z))                 S (S (S (S O)))
           5            B1 (B0 (B1 Z))              S (S (S (S (S O))))
           6            B0 (B1 (B1 Z))           S (S (S (S (S (S O)))))
           7            B1 (B1 (B1 Z))        S (S (S (S (S (S (S O))))))
           8        B0 (B0 (B0 (B1 Z)))    S (S (S (S (S (S (S (S O)))))))

    注意到在上面的表示中，二进制数的低位被写在左边而高位写在右边。
    这与通常的二进制写法相反，这种写法可以让我们在证明中更好的操作他们。

    （理解检查：[B0 Z] 代表的二进制数是多少？) *)

Inductive bin : Type :=
  | Z
  | B0 (n : bin)
  | B1 (n : bin).

(** 补全下面二进制自增函数 [incr] 的定义。并且补全二进制数与一进制自然数转换的
    函数 [bin_to_nat]。 *)

Fixpoint incr (m:bin) : bin
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

Fixpoint bin_to_nat (m:bin) : nat
  (* REPLACE THIS LINE WITH ":= _your_definition_ ." *). Admitted.

(** 下面这些针对单增函数和二进制转换函数的「单元测试」可以验算你的定义的正确性。
    当然，这些单元测试并不能确保你的定义在所有输入下都是正确的！我们在下一章的
    末尾会重新回到这个话题。 *)

Example test_bin_incr1 : (incr (B1 Z)) = B0 (B1 Z).
(* FILL IN HERE *) Admitted.

Example test_bin_incr2 : (incr (B0 (B1 Z))) = B1 (B1 Z).
(* FILL IN HERE *) Admitted.

Example test_bin_incr3 : (incr (B1 (B1 Z))) = B0 (B0 (B1 Z)).
(* FILL IN HERE *) Admitted.

Example test_bin_incr4 : bin_to_nat (B0 (B1 Z)) = 2.
(* FILL IN HERE *) Admitted.

Example test_bin_incr5 :
        bin_to_nat (incr (B1 Z)) = 1 + bin_to_nat (B1 Z).
(* FILL IN HERE *) Admitted.

Example test_bin_incr6 :
        bin_to_nat (incr (incr (B1 Z))) = 2 + bin_to_nat (B1 Z).
(* FILL IN HERE *) Admitted.

Example test_bin_incr7 : bin_to_nat (B0 (B0 (B0 (B1 Z)))) = 8.
(* FILL IN HERE *) Admitted.

(** [] *)

(* ################################################################# *)
(** * 可选：测试你的解答 *)

(** 《【软件基础|SF】》的每一章都附带一个测试文件，其中包含用于检查你是否已解答必做练习的脚本。
    如果你在课程中学习 SF，你的讲师很可能会运行这些测试文件来对你的解答进行自动评分。
    如果你愿意，也可以使用这些测试文件来确保你没有遗漏任何内容。

    重要提示：这一步是【可选的】：如果你完成了所有非可选的练习，并且 Rocq 接受了你的解答，
    这已经表明你的状态非常完美了。

    本章的测试文件为 [BasicsTest.v]。要运行它，请确保已将 [Basics.v] 保存到磁盘。
    然后首先运行 [rocq compile -Q . LF Basics.v]，接着运行 [rocq compile -Q . LF BasicsTest.v]；
    或者，如果你安装了 make，可以运行 [make BasicsTest.vo]。
    （请确保在一个同样包含名为 [_RocqProject] 的文件的目录中进行此操作，
    该文件只包含单行内容 [-Q . LF]。）

    如果你不小心删除了某个练习或更改了其名称，那么 [make BasicsTest.vo] 会运行失败，
    并抛出错误，提示你所缺失的练习名称。否则，你将获得许多有用的输出：

    - 首先是 [Basics.v] 本身所产生的所有输出。

    - 其次，对于每个必做练习，都会有一份报告，说明其分值（如果该练习包含多个部分，
      则为星数或其一部分分数）、类型是否 [ok]，以及它依赖哪些假设。

      如果【类型|type】不是 [ok]，则意味着你证明了错误的内容：
      最常见的情况是，你在证明定理时无意中修改了定理陈述。
      在这种情况下，自动评分器不会给你任何分数，所以请务必纠正定理。

      【假设|assumptions】是你的解答所依赖的任何未证明的定理。
      「【在全局上下文中关闭|Closed under the global context】」是表示「无」的专业说法：
      即你已经解答了该练习。（太棒了！）另一方面，公理列表意味着你尚未完全解答
      该练习（但请参阅下面关于「【允许的公理|Allowed Axioms】」的部分）。如果练习
      名称本身包含在列表中，那意味着你还没有解答它，可能你使用了 [Admitted]。

    - 第三，你将看到标准版和高级版作业的最高分数。该分数是根据非可选练习中的
      星级数量计算出来的。（在本文件中，没有高级练习。）

    - 第四，你将看到一个「【允许的公理|Allowed Axioms】」列表。这些是你的解答允许依赖的、
      除 Rocq 逻辑的基本公理之外的未证明定理。对于本章，你可能会在列表中看到
      关于 【[functional_extensionality]|函数外延性】 的内容；我们将在后续章节中介绍它的含义。

    - 最后，你将看到一个关于你是否解答了每个练习的摘要。请注意，该摘要并不包含
      类型是否 [ok]（即你是否不小心更改了定理陈述）这一关键信息：你必须在上方查看该信息。

    需要手动评分的练习也会显示在输出中。但由于它们必须由人工评分，
    测试脚本无法提供关于它们的太多信息。  *)

(* 2026-06-19 18:13 *)

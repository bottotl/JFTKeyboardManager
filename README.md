# JFTKeyboardManager
keyboard manager for iOS
## demo
（demo 有更新，但是还没有做 gif）
![](http://markdown-1254413962.cossh.myqcloud.com/%E9%94%AE%E7%9B%98%E7%AE%80%E4%BB%8B.gif)


## 本项目做的初衷

目前有很多流行的通用的键盘隐藏策略如 IQKeyboardManager，TPKeyboardAvoid，但是都不太能符合现在业务的要求
但是项目中出于定制化的需求的考虑，开源框架无法满足。

**他们解决的都是正常的业务需求：**
**如果在一个ScrollView中含有多个支持输入的组件（UITextView、UITextField），当多个输入框进行切换的过程中需要防止键盘遮挡，可以通过计算当前导致键盘弹起的输入组件计算一个防止键盘遮挡的偏移量，修改 ScrollView 的 contentOffset 快速实现一个防止键盘遮挡的能力**

但是在项目中遇到的情况和这里却有所区别。我们提供了一系列通用的 UI 组件（feed），以**类似 UITableViewCell**的形式提供给业务方使用，其中包含了评论按钮。
正常的业务逻辑是，当点击按钮的时候需要从屏幕底部向上弹起一个输入框，用户在输入框中输入评论内容以后点击回复键盘下降，输入框落下，发网络请求。

如果其他业务方需要使用评论的流程，我们会提供相关代码，对方 copy 一份，把逻辑写在 VC 中。其中涉及到大致如下工作量：

ps：messageBar 的样式可以参考微信聊天的输入框

1. 创建 messageBar，并且放在 VC 的合适区域
2. 监听键盘变化，调整 messageBar 的位置
3. 记录需要滚动的位移，在键盘变化的时候调整 scrolleView 的 contentOffset
4. 创建手势，点击空白区域让键盘落下（TextView resignFirstResponder）
5. 监听 messageBar 的输入变化&点击回车，进行网络请求

在保持现有的低耦合度不变的前提下，分析1-4过程可以被统一管理，故此做了一个 manager 方便业务方快速实现 feed 的接入。

### 为什么第三方不能解决定制化的的问题？

我们假设有如下三种场景

1. ScrollView 中有输入框
2. ScrollView 中没有输入框，但是有评论按钮。页面中有一个长期露出的 messageBar
3. ScrollView 中没有输入框，但是有评论按钮。页面中有一个在需要输入框的时候才会露出，不需要的时候（没点击评论的时候）隐藏的 messageBar。

一开始觉得 UIResponder 的 inputAccessView 似乎能够解决这个问题，但是调研以后发现实现起来并不理想

1. UIResponder 的 inputAccessView 属性是只读的
2. messageBar 长期露出没办法解决
3. inputAccessView 的高度没办法灵活变化

inputAccessView 的高度没办法灵活变化这点还挺有趣的，系统的键盘会被放在一个专门的 window 中，创建了一个 VC 其中用两个 childViewControllerView 分别提供里两个 containder View 管理 inputAccessView 和 inputView，高度定死，reloadInputView 也没办法解决上述需求。

**为什么使用 jft_needMessageBar 必须要求 view 不能为 scrolleView**

假设一个页面直接继承自 UITableViewController，那 messageBar 应该添加在哪里？tableView 上？肯定不合适。因为这样会导致滑动过程中输入框跟着一起动。
如果贴在 window 上呢？那页面侧滑的时候 messageBar 又不能跟着滑动，体验上不符合用户预期。
故此如果需要使用项目中的 messageBar，必须保证页面不能重写 loadView 方法，把 VC 的 view 替换成 UIScrolleView 以及他的子类，否则根本没办法做

**为什么 messageBar 采用了 autolayout 布局而没有用绝对布局**

我们项目中大部分代码都采用绝对布局保证 UI 布局的效率，性能调优&debug的时候也能快速定位问题，不用解决一堆约束依赖的问题。
这里用 autolayout 还是考虑到为了保证 UIViewController category 的干净程度。如果绝对布局就势必需要记录很多数据： keyboard 的 frame，当前键盘是否出现了，自增长的 textView 的高度变化时需要监听其变化动态调整。UIViewController category 中只接收两个参数：键盘隐藏与否、bottomInset，以此决定了 messageBar 最终的样式。

**textInputTrigger 使用准则**

manager 中会动态查找三个对象

1. currentActiveTextView
2. textInputTrigger
3. ScrolleView

其中 textInputTrigger 这个属性是在写demo后期加进来的，为了解决 scrollView 到底应该滚动到什么位置的问题。这个属性有可能并不是开发者所预期的。
正常的情况下，UI 组件的提供者在提供了评论按钮，点击以后先把自己声明为 textInputTrigger ，紧接着弹起一个 messageBar， manager 中就能够知道是评论按钮需要被对齐，计算出一个合适的 contentOffset。

但是不同业务方对于业务的定制化千奇百怪，有且会规定点击评论跳转到 feed 的详情页面，在详情页延迟一会儿触发详情页的 messageBar 的弹起。这时候 manager 会认为，键盘弹起是由于上个页面的评论按钮导致的，计算就会出问题。所以 manager 中会对这种异常的情况做出判断，如果 textInputTrigger 的 window 为空，则判断符合这种异常情况，Keyboard avoid 的逻辑不走。

在用这个属性的时候必须保证在**每次**键盘弹起之前设置这个属性，否则会出现异常

**可能会出现异常的情况**

manager 中会动态查找离 textInputTrigger 最近的一个能够滑动的 ScrolleView，当出现 ScrolleView 嵌套的情况下一定会出现查找异常，导致显示异常。
既然做成自动化的通用组件，在保持其低耦合度的前提下，除非把类似 tableView 之类的基础组件也一整套打包提供（这样可定制化程度就低了），否则动态查找的流程不能避免，这部分应该挺难优化的。

## 思维导图

![](http://markdown-1254413962.cossh.myqcloud.com/2018-03-15-12-44-39.png)

![](http://markdown-1254413962.cossh.myqcloud.com/2018-03-15-12-46-13.png)

## Usage

1. 仿微信文本输入框
2. 防止输入框被遮挡
3. 任意 TextView 添加键盘隐藏和显示 emoji 键盘的 ToolBar

## How to use

**所有category 都在 JFTKeyboard.h 中声明**

### 1. 给输入框添加 ToolBar——包含 `Emoji 键盘`和 `隐藏键盘`

**给TextView设置属性**

```objective-c
self.textView.jft_needInputAccessoryView = YES;
```

### 2. 防止输入框被遮挡

**给TextView设置属性**

```objective-c
self.textView.jft_needAvoidKeyboardHide  = YES;
```

### 3. 点击非输入框区域自动隐藏键盘

**给TextView设置属性**

```objective-c
self.textView.jft_shouldResignOnTouchOutside = YES;
```

### 4. 给页面添加仿微信的输入框

**设置 jft_needMessageBar 属性**

```objective-c
self.jft_needMessageBar = YES;
```

如果希望有点击其他区域隐藏键盘的需求，设置如下的值

```objective-c
self.jft_messageBar.textView.jft_shouldResignOnTouchOutside = YES;
```

如果希望点击一个按钮，弹起 messageBar 并且按钮的下边缘（或其他位置）对齐 messageBar 的顶部

```objective-c
- (void)triggerTestA:(UIButton *)sender {
    [sender jft_becomeTextInputTrigger];
    //务必确认在键盘弹起之前调用按钮的 jft_becomeTextInputTrigger
    [self.jft_messageBar becomeFirstResponder];
}

```


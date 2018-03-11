# JFTKeyboardManager
keyboard manager for iOS

![](http://markdown-1254413962.cossh.myqcloud.com/%E9%94%AE%E7%9B%98%E7%AE%80%E4%BB%8B.gif)

IQKeyboardManager 不太能符合现在业务的要求，出于定制化的需求，做了一个简单的 demo，目前的 UI 很简陋。

## Usage

1. 仿微信文本输入框
2. 防止输入框被遮挡
3. 任意 TextView 添加键盘隐藏和显示 emoji 键盘的 ToolBar

## How to use

### 1. 给输入框添加 ToolBar——包含 `Emoji 键盘`和 `隐藏键盘` 

**导入头文件 UIResponder+JFTKeyboard.h**

**给TextView设置属性**

```
self.textView.jft_needInputAccessoryView = YES;
```



### 2. 防止输入框被遮挡

**导入头文件 UIResponder+JFTKeyboard.h**

**给TextView设置属性**

```
self.textView.jft_needAvoidKeyboardHide  = YES;
```



### 3. 点击非输入框区域自动隐藏键盘

**导入头文件 UIResponder+JFTKeyboard.h**

**给TextView设置属性**

```
self.textView.jft_shouldResignOnTouchOutside = YES;
```



### 4. 给页面添加仿微信的输入框

**导入头文件 UIViewController+JFTTextInput.h**

**设置 jft_needMessageBar 属性**

```
self.jft_needMessageBar = YES;
```

如果希望有点击其他区域隐藏键盘的需求，设置如下的值

```
self.jft_messageBar.textView.jft_shouldResignOnTouchOutside = YES;
```


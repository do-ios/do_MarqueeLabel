//
//  do_MarqueeLabel_View.m
//  DoExt_UI
//
//  Created by @userName on @time.
//  Copyright (c) 2015年 DoExt. All rights reserved.
//

#import "do_MarqueeLabel_UIView.h"

#import "doInvokeResult.h"
#import "doUIModuleHelper.h"
#import "doScriptEngineHelper.h"
#import "doIScriptEngine.h"
#import "doAutoScrollLabel.h"
#import "doUIModuleHelper.h"
#import "doTextHelper.h"

@interface do_MarqueeLabel_UIView()
{
    doAutoScrollLabel *_marqueeLabel;
}

@end
@implementation do_MarqueeLabel_UIView
#pragma mark - doIUIModuleView协议方法（必须）
//引用Model对象
- (void) LoadView: (doUIModule *) _doUIModule
{
    _model = (typeof(_model)) _doUIModule;
    NSInteger fontSize = [doUIModuleHelper GetDeviceFontSize:[[_model GetProperty:@"fontSize"].DefaultValue intValue] :_model.XZoom :_model.YZoom];
    _marqueeLabel = [[doAutoScrollLabel alloc]initWithFrame:CGRectMake(0,0, _model.RealWidth, _model.RealHeight) withFontSize:fontSize];
    [self addSubview:_marqueeLabel];
}
//销毁所有的全局对象
- (void) OnDispose
{
    //自定义的全局属性,view-model(UIModel)类销毁时会递归调用<子view-model(UIModel)>的该方法，将上层的引用切断。所以如果self类有非原生扩展，需主动调用view-model(UIModel)的该方法。(App || Page)-->强引用-->view-model(UIModel)-->强引用-->view
    _marqueeLabel = nil;
    
}
//实现布局
- (void) OnRedraw
{
    //实现布局相关的修改,如果添加了非原生的view需要主动调用该view的OnRedraw，递归完成布局。view(OnRedraw)<显示布局>-->调用-->view-model(UIModel)<OnRedraw>
    
    //重新调整视图的x,y,w,h
    [doUIModuleHelper OnRedraw:_model];
    _marqueeLabel.frame = CGRectMake(0 ,0, _model.RealWidth, _model.RealHeight);
}

#pragma mark - TYPEID_IView协议方法（必须）
#pragma mark - Changed_属性
/*
 如果在Model及父类中注册过 "属性"，可用这种方法获取
 NSString *属性名 = [(doUIModule *)_model GetPropertyValue:@"属性名"];
 
 获取属性最初的默认值
 NSString *属性名 = [(doUIModule *)_model GetProperty:@"属性名"].DefaultValue;
 */
- (void)change_direction:(NSString *)newValue
{
    //自己的代码实现
    if ([newValue isEqualToString:@"left"]) {
        _marqueeLabel.direction = 0;
    }
    else if ([newValue isEqualToString:@"right"])
    {
        _marqueeLabel.direction = 1;
    }
    if (!_marqueeLabel.isStart) {
        [_marqueeLabel start];
    }
}

- (void)change_fontColor:(NSString *)newValue
{
    //自己的代码实现
    UIColor *fontColor = [doUIModuleHelper GetColorFromString:newValue :[UIColor clearColor]];
    _marqueeLabel.fontColor = fontColor;
}
- (void)change_fontSize:(NSString *)newValue
{
    //自己的代码实现
    NSInteger fontSize = [doUIModuleHelper GetDeviceFontSize:[[doTextHelper Instance] StrToInt:newValue :[[_model GetProperty:@"fontSize"].DefaultValue intValue]] :_model.XZoom :_model.YZoom];
    _marqueeLabel.fontSize = fontSize;
}
- (void)change_fontStyle:(NSString *)newValue
{
    //自己的代码实现
    _marqueeLabel.fontStyle = newValue;
}
- (void)change_text:(NSString *)newValue
{
    //自己的代码实现
    _marqueeLabel.text = newValue;
    if (!_marqueeLabel.isStart) {
        [_marqueeLabel start];
    }
}
- (void)change_textFlag:(NSString *)newValue
{
    //自己的代码实现
    _marqueeLabel.textFlag = newValue;
}

#pragma mark - doIUIModuleView协议方法（必须）<大部分情况不需修改>
- (BOOL) OnPropertiesChanging: (NSMutableDictionary *) _changedValues
{
    //属性改变时,返回NO，将不会执行Changed方法
    return YES;
}
- (void) OnPropertiesChanged: (NSMutableDictionary*) _changedValues
{
    //_model的属性进行修改，同时调用self的对应的属性方法，修改视图
    [doUIModuleHelper HandleViewProperChanged: self :_model : _changedValues ];
}
- (BOOL) InvokeSyncMethod: (NSString *) _methodName : (NSDictionary *)_dicParas :(id<doIScriptEngine>)_scriptEngine : (doInvokeResult *) _invokeResult
{
    //同步消息
    return [doScriptEngineHelper InvokeSyncSelector:self : _methodName :_dicParas :_scriptEngine :_invokeResult];
}
- (BOOL) InvokeAsyncMethod: (NSString *) _methodName : (NSDictionary *) _dicParas :(id<doIScriptEngine>) _scriptEngine : (NSString *) _callbackFuncName
{
    //异步消息
    return [doScriptEngineHelper InvokeASyncSelector:self : _methodName :_dicParas :_scriptEngine: _callbackFuncName];
}
- (doUIModule *) GetModel
{
    //获取model对象
    return _model;
}

@end

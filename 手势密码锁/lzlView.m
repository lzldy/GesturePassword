//
//  lzlView.m
//  手势密码锁
//
//  Created by lzldy on 16/2/25.
//  Copyright © 2016年 lzldy. All rights reserved.
//

#import "lzlView.h"
//const  定义只读变量(不可修改，重新复制) 在其他类中也不能声明同样的变量名
CGFloat const btnCount =9;  //按钮个数
CGFloat const btnW     =74 ;//按钮宽度
CGFloat const btnH     =74 ;//按钮高度
int const columnCount  =3 ; //总共有3列
#define KScreenWidth   [UIScreen mainScreen].bounds.size.width

//匿名扩展（类目的特列）：可以声明属性
@interface lzlView ()
@property (nonatomic,strong) NSMutableArray *selectBtns;
@property (nonatomic,assign) CGPoint currentPoint;
@end

@implementation lzlView

-(NSMutableArray *)selectBtns{
    if (_selectBtns == nil) {
        _selectBtns = [NSMutableArray array];
    }
    return _selectBtns;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self addBtn];
    }
    return self;
}

-(void)addBtn{
    CGFloat height = 0;
    for (int i= 0; i<btnCount; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.userInteractionEnabled=NO;
        btn.tag=i;
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        
        int row    = i/columnCount;//第几行
        int column = i%columnCount;//第几列

        // 间距
        CGFloat margin = (self.frame.size.width -columnCount*btnW)/(columnCount+1);
        // X
        CGFloat btnX =margin +column *(btnW +margin);
        // Y
        CGFloat btnY =row *(btnW +margin);
        btn.frame =CGRectMake(btnX, btnY, btnW, btnH);
        
        height =btnH +btnY;
        [self addSubview:btn];
    }
    self.backgroundColor=[UIColor clearColor];
    self.frame =CGRectMake(0, self.frame.origin.y, KScreenWidth, height);
}

-(CGPoint)pointWithTouch:(NSSet *)touchs{
    UITouch * touch =[touchs anyObject];
    CGPoint   point =[touch locationInView:self];
    return point;
}

-(UIButton *)buttonWithPoint:(CGPoint)point{
    for (UIButton *btn in self.subviews) {
        //如果这个点 在btn的frame范围内
        if (CGRectContainsPoint(btn.frame, point)) {
            return btn;
        }
    }
    return nil;
}

//触摸方法
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event{
    //拿到触摸的点
    CGPoint point =[self pointWithTouch:touches];
    //通过点 得到相应按钮
    UIButton *btn =[self buttonWithPoint:point];
    //设置状态
    if (btn && btn.selected ==NO) {
        btn.selected =YES;
        [self.selectBtns addObject:btn];
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event{
    //拿到触摸的点
    CGPoint point =[self pointWithTouch:touches];
    //通过点 得到相应按钮
    UIButton *btn =[self buttonWithPoint:point];
    //设置状态
    if (btn && btn.selected ==NO) {
        btn.selected =YES;
        [self.selectBtns addObject:btn];
    }else{
        self.currentPoint = point;
    }
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(lockView:didFinishPath:)]) {
        NSMutableString *path= [NSMutableString string];
        for (UIButton *button in self.selectBtns) {
            [path appendFormat:@"%ld",(long)button.tag];
        }
        [self.delegate lockView:self didFinishPath:path];
    }
    
    //清空按钮的状态
    [self.selectBtns makeObjectsPerformSelector:@selector(setSelected:) withObject:0];
    [self.selectBtns removeAllObjects];
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent *)event{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect{
    if (self.selectBtns.count ==0) {
        return;
    }
    //线
    UIBezierPath *path =[UIBezierPath bezierPath];
    path.lineWidth=8;
    path.lineJoinStyle =kCGLineJoinRound;
    [[UIColor colorWithRed:225/255 green:79/255 blue:89/255 alpha:0.5] set];
    //遍历按钮
    for (int i =0; i< self.selectBtns.count; i++) {
        UIButton *button =self.selectBtns[i];
        if (i==0) {//起点
            [path moveToPoint:button.center];
        }else{//连线
            [path addLineToPoint:button.center];
        }
    }
    [path addLineToPoint:self.currentPoint];
    [path stroke];
}
@end

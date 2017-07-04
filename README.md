# DDCornerRadius
优化图片圆角处理,避免离屏渲染引发的性能损耗（卡顿）。

# Usage

导入头文件

```
#import "DDCornerRadius.h"
```

方案一：

```
imageView.image = [[UIImage imageNamed:@"demo3"] dd_imageByCornerRadius:40.0 corners:(UIRectCornerTopLeft | UIRectCornerBottomRight) borderWidth:5.0 borderColor:[UIColor redColor]];
```

方案二：

```
imageView = [UIImageView dd_cornerWithRadius:40.0 cornerColor:[UIColor redColor] corners:(UIRectCornerTopLeft | UIRectCornerBottomRight) ];
```

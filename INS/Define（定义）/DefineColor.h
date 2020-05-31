


#ifndef DefineColor_h
#define DefineColor_h

#define RGBA(R,G,B,A) [UIColor colorWithRed: R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define RGB(r,g,b)               RGBA(r,g,b,1.0)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define COLOR_RGB(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]


#define RGBA(R,G,B,A) [UIColor colorWithRed: R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define RGB(r,g,b)               RGBA(r,g,b,1.0)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


#define HEXCOLOR(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16)) / 255.0 green:((float)((hex & 0xFF00) >> 8)) / 255.0 blue:((float)(hex & 0xFF)) / 255.0 alpha:1]

#define COLOR_RGB(rgbValue,a) [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 green:((float)(((rgbValue) & 0xFF00)>>8))/255.0 blue: ((float)((rgbValue) & 0xFF))/255.0 alpha:(a)]

// 主色调（浅）
#define COLOR_MAIN_Wave RGBA(145,162,239,1.0)

// 主色调
#define COLOR_MAIN RGBA(43,146,239,1.0)
// 副色调
#define COLOR_SECOND RGBA(253,130,74,1.0)
// 背景颜色
#define COLOR_BACKGROUND RGBA(238, 237, 238,1.0)
// 边框颜色
#define COLOR_BORDER RGBA(222,222,222,1.0)
// 编辑边框颜色
#define COLOR_BORDER_EDIT RGBA(136,172,226,1.0)

// 导航栏底部线条颜色
#define COLOR_NAVIBAR_BOTTOM_LINE_COLOR RGBA(215,215,215,1.0)



#endif /* DefineColor_h */

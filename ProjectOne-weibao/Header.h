//
//  Header.h
//  ProjectOne-weibao
//
//  Created by jack on 16/6/17.
//  Copyright © 2016年 伍新科技有限公司. All rights reserved.
//

#ifndef Header_h
#define Header_h

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define UIColorRGB(r , g , b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define kWidth [UIScreen mainScreen].bounds.size.width

#define kHeight [UIScreen mainScreen].bounds.size.height

#if 1 //----------------------------------------------------------------------------

#define BOOKDETAILINFO @"http://www.yjoof.com/ygapi/myBespeaks?"

#define DELETBOOKINFO @"http://www.yjoof.com/ygapi/deletemyBespeaks?"

#define READURL @"http://www.yjoof.com/ygapi/saveusages?"

#define SAVELOGO @"http://www.yjoof.com/ygapi/savelogo?"

#define UPLOADIMAGE  @"http://www.yjoof.com/api/uploadImages"

#define CHECKBOOK @"http://www.yjoof.com/ygapi/checkBespeak?"

#define DOWNLOADAIMAGE  @"http://www.yjoof.com/"

#define YANURL @"http://www.yjoof.com/ygapi/getcode?"

#define RESETURL @"http://www.yjoof.com/ygapi/changepass?"

#define MESSAGE @"http://www.yjoof.com/ygapi/sendmsg?"

#define FORGETPASSWORD @"http://www.yjoof.com/ygapi/wjmm?"

#define LoginURL @"http://www.yjoof.com/ygapi/phonelogin?"

#define FindURL @"http://www.yjoof.com/ygapi/changepass?"

#define POSTURL @"http://www.yjoof.com/ygapi/savefkbg?"

#define DELETBOOKINFO @"http://www.yjoof.com/ygapi/deletemyBespeaks?"

#define CANCLEBOOKINFO @"http://www.yjoof.com/ygapi/cancelmyBespeaks?"

#define UPLOADDELAYTIME @"http://www.yjoof.com/ygapi/updatebespeak?"

#define TIMEREND @"http://www.yjoof.com/ygapi/sfjs?"

#define CHANGEPASSURL   @"http://www.yjoof.com/ygapi/changepass?"

#define BOOKURL @"http://www.yjoof.com/ygapi/savebespeak?"

#define ROOMURL @"http://www.yjoof.com/ygapi/getrooms?"

//------------------------------------------绑定API------------------------------------------------------

#define SAOMIAOCHAZUO @"http://www.yjoof.com/ygapi/findbymac?"

#define MOHUCHAXUN  @"http://www.yjoof.com/ygapi/findAssetbyNum?"

#define CHAZUOBANGDING @"http://www.yjoof.com/ygapi/bindMachine?"

#define JIECHUBANGDING @"http://www.yjoof.com/ygapi/canclebindMachine?"

#define CHAPAICHAKONGBANDDING @"http://www.yjoof.com/ygapi/bindHub?"

#define JIECHUCHAPAICHAKONGBANDDING @"http://www.yjoof.com/ygapi/cancelbindHub?"

#define CHECKBINDING @"http://www.yjoof.com/ygapi/checkbindinfo"

#else //--------------------------------------------------------------------------------------

//#define READURL1 @"http://192.168.5.10:8080/wuxin/ygapi/saveusages?"
//
//#define YANURL1 @"http://192.168.5.10:8080/wuxin/ygapi/getcode?"
//
//#define RESETURL1 @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"
//
//#define MESSAGE1 @"http://192.168.5.10:8080/wuxin/ygapi/sendmsg?"
//
//#define FORGETPASSWORD1 @"http://192.168.5.10:8080/wuxin/ygapi/wjmm?"
//
//#define LoginURL1 @"http://192.168.5.10:8080/wuxin/ygapi/phonelogin?"
//
//#define FindURL1 @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"
//
//#define POSTURL1 @"http://192.168.5.10:8080/wuxin/ygapi/savefkbg?"
//
//#define UPLOADDELAYTIME1 @"http://192.168.5.10:8080/wuxin/ygapi/updatebespeak?"
//
//#define CHANGEPASSURL1   @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"
//
//#define BOOKURL1 @"http://192.168.5.10:8080/wuxin/ygapi/savebespeak?"
//
//#define ROOMURL1 @"http://192.168.5.10:8080/wuxin/ygapi/getrooms?"

//------------------------------公司内网----------------------------------------------
#define BOOKDETAILINFO @"http://192.168.5.10:8080/wuxin/ygapi/myBespeaks?"

#define DELETBOOKINFO @"http://192.168.5.10:8080/wuxin/ygapi/deletemyBespeaks?"

#define READURL @"http://192.168.5.10:8080/wuxin/ygapi/saveusages?"

#define SAVELOGO @"http://192.168.5.10:8080/wuxin/ygapi/savelogo?"

#define UPLOADIMAGE  @"http://192.168.5.10:8080/wuxin/api/uploadImages"

#define CHECKBOOK @"http://192.168.5.10:8080/wuxin/ygapi/checkBespeak?"

#define DOWNLOADAIMAGE @"http://192.168.5.10:8080/wuxin/"

#define YANURL @"http://192.168.5.10:8080/wuxin/ygapi/getcode?"

#define RESETURL @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"

#define MESSAGE @"http://192.168.5.10:8080/wuxin/ygapi/sendmsg?"

#define FORGETPASSWORD @"http://192.168.5.10:8080/wuxin/ygapi/wjmm?"

#define LoginURL @"http://192.168.5.10:8080/wuxin/api/phonelogin?"  //登陆表合并维码头 ygapi改成api 其他不变 （线上暂未改变）

#define FindURL @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"

#define POSTURL @"http://192.168.5.10:8080/wuxin/ygapi/savefkbg?"

#define DELETBOOKINFO @"http://192.168.5.10:8080/wuxin/ygapi/deletemyBespeaks?"

#define CANCLEBOOKINFO @"http://192.168.5.10:8080/wuxin/ygapi/cancelmyBespeaks?"

#define UPLOADDELAYTIME @"http://192.168.5.10:8080/wuxin/ygapi/updatebespeak?"

#define TIMEREND @"http://192.168.5.10:8080/wuxin/ygapi/sfjs?"

#define CHANGEPASSURL @"http://192.168.5.10:8080/wuxin/ygapi/changepass?"

#define BOOKURL @"http://192.168.5.10:8080/wuxin/ygapi/savebespeak?"

#define ROOMURL @"http://192.168.5.10:8080/wuxin/ygapi/getrooms?"

//---------------------------------绑定插座API--------------------------------------------------

#define SAOMIAOCHAZUO @"http://192.168.5.10:8080/wuxin/ygapi/findbymac?"

#define MOHUCHAXUN  @"http://192.168.5.10:8080/wuxin/ygapi/findAssetbyNum?"

#define CHAZUOBANGDING @"http://192.168.5.10:8080/wuxin/ygapi/bindMachine?"

#define JIECHUBANGDING @"http://192.168.5.10:8080/wuxin/ygapi/cancelbindMachine?"

#define CHAPAICHAKONGBANDDING @"http://192.168.5.10:8080/wuxin/ygapi/bindHub?"

#define JIECHUCHAPAICHAKONGBANDDING @"http://192.168.5.10:8080/wuxin/ygapi/cancelbindHub?"

#define CHECKBINDING @"http:192.168.5.10:8080/wuxin/ygapi/checkbindinfo"

//-------------------------校园内网部署-----------------------------------------------
//#define BOOKDETAILINFO @"http://192.168.5.150:8080/wuxin/ygapi/myBespeaks?"
//
//#define DELETBOOKINFO @"http://192.168.5.150:8080/wuxin/ygapi/deletemyBespeaks?"
//
//#define READURL @"http://192.168.5.150:8080/wuxin/ygapi/saveusages?"
//
//#define SAVELOGO @"http://192.168.5.150:8080/wuxin/ygapi/savelogo?"
//
//#define UPLOADIMAGE  @"http://192.168.5.150:8080/wuxin/api/uploadImages"
//
//#define CHECKBOOK @"http://192.168.5.150:8080/wuxin/ygapi/checkBespeak?"
//
//#define DOWNLOADAIMAGE @"http://192.168.5.150:8080/wuxin/"
//
//#define YANURL @"http://192.168.5.150:8080/wuxin/ygapi/getcode?"
//
//#define RESETURL @"http://192.168.5.150:8080/wuxin/ygapi/changepass?"
//
//#define MESSAGE @"http://192.168.5.150:8080/wuxin/ygapi/sendmsg?"
//
//#define FORGETPASSWORD @"http://192.168.5.150:8080/wuxin/ygapi/wjmm?"
//
//#define LoginURL @"http://192.168.5.150:8080/wuxin/ygapi/phonelogin?"
//
//#define FindURL @"http://192.168.5.150:8080/wuxin/ygapi/changepass?"
//
//#define POSTURL @"http://192.168.5.150:8080/wuxin/ygapi/savefkbg?"
//
//#define DELETBOOKINFO @"http://192.168.5.150:8080/wuxin/ygapi/deletemyBespeaks?"
//
//#define CANCLEBOOKINFO @"http://192.168.5.150:8080/wuxin/ygapi/cancelmyBespeaks?"
//
//#define UPLOADDELAYTIME @"http://192.168.5.150:8080/wuxin/ygapi/updatebespeak?"
//
//#define TIMEREND @"http://192.168.5.150:8080/wuxin/ygapi/sfjs?"
//
//#define CHANGEPASSURL @"http://192.168.5.150:8080/wuxin/ygapi/changepass?"
//
//#define BOOKURL @"http://192.168.5.150:8080/wuxin/ygapi/savebespeak?"
//
//#define ROOMURL @"http://192.168.5.150:8080/wuxin/ygapi/getrooms?"



#endif //-------------------------------------------------------------------------------------


#endif /* Header_h */

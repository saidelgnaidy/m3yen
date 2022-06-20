
import 'package:flutter/material.dart';

import '../../constants.dart';

String policy = 'عند استخدام خدماتنا، فإنك تأتمننا على معلوماتك. نحن ندرك أن هذه مسؤولية كبيرة ونعمل بجدية لحماية معلوماتك ونمنحك التحكم فيها,تهدف سياسةُ الخصوصية هذه إلى مساعدتك على فهم ماهية المعلومات التي نجمعها وسبب جمعنا لها، وكذلك طريقة تحديث معلوماتك وتصديرها وحذفها.';
String termsOfUse = 'تتجدد شروط الاستخدام من حين لآخر، وفي حالة إجراء مثل هذه التحديثات سيعرض تطبيق وثاق تنبيهات لكي يكون       (العميل / مقدم الخدمة) على علم بها. استمرار المُستخدِم في استعمال تطبيق وثاق قائم على قبول شروط وأحكام الاستخدام الآتية، حسب ما يجري تعديلها من وقت لآخر من أجل خدمة أفضل وجودة أعلى. علماً بأن أي مخالفة لهذه الاتفاقية من قبل (العميل / مقدم الخدمة) قد تعرض حسابه للإيقاف دون إشعار مسبق وبلا أي مبالغ مسترجعة في بعض الحالات';
String about = 'معين هو تطبيق يساعدك علي ايجاد شخص مناسب لمساعدتك في بعض المجالات مثل رعاية الاطفال و مراعة اصحاب الهمم و رعاية المسنين و العديد من المجالات  التي تساعدك في منزلك';
termsOfUseDialog(BuildContext context){
  showDialog(
    context: context,builder:(context)=>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('الشروط والاحكام', style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(termsOfUse, style:  TextStyle(color: Colors.grey[700]),textAlign: TextAlign.center,),
          ],
        ),
        actions: <Widget>[
          RawMaterialButton(
            onPressed:()=> Navigator.pop(context),
            child: Text('رجوع' ,style: TextStyle(color: Colors.white),),
            fillColor: kPrimaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
  );
}



policyDialog(BuildContext context){
  showDialog(
    context: context,builder:(context)=>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('سياسة الخصوصية', style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),textAlign: TextAlign.center,),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(policy, style:  TextStyle(color: Colors.grey[700]),textAlign: TextAlign.center,),
          ],
        ),
        actions: <Widget>[
          RawMaterialButton(
            onPressed:()=> Navigator.pop(context),
            child: Text('رجوع' ,style: TextStyle(color: Colors.white),),
            fillColor: kPrimaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
  );
}

aboutDialog(BuildContext context){
  showDialog(
    context: context,builder:(context)=>
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('عن التطبيق', style:  TextStyle(fontWeight: FontWeight.bold , fontSize:  18),textAlign: TextAlign.center,),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(about, style:  TextStyle(fontSize:  14,color: Colors.grey[700]),textAlign: TextAlign.center,),
          ],
        ),
        actions: <Widget>[
          RawMaterialButton(
            onPressed:()=> Navigator.pop(context),
            child: Text('رجوع' ,style: TextStyle(color: Colors.white),),
            fillColor: kPrimaryColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
        ],
      ),
  );
}


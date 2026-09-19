# مسرد المصطلحات — تعريب OPNsense

قرارات المصطلحات المعتمدة في هذه الترجمة ومصادرها.

راجعت نحو 85 مصطلحًا أساسيًا مقابل المصادر التالية:
- صفحات Microsoft Learn العربية (ar-sa) وsupport.microsoft.com. **ملاحظة:** معظمها مترجم آليًا.
- ويكيبيديا العربية.
- واجهة ESET العربية.

طُبّق التغيير فقط على النصوص التي يحتوي أصلها الإنجليزي على المصطلح المعني، حتى لا يُستبدل المصطلح حيث يعني شيئًا آخر، ثم رُوجع التذكير والتأنيث في الجمل التي تغيّرت.

## مصطلحات تم تغييرها

| الإنجليزية | كان | أصبح | المصدر |
|---|---|---|---|
| Latency | زمن الاستجابة | **زمن الانتقال** | learn.microsoft.com/ar-sa/azure/virtual-network/virtual-network-tcpip-performance-tuning ، learn.microsoft.com/ar-sa/azure/load-balancer/load-balancer-overview |
| DNS Forwarder | مُحوِّل DNS | **معيد توجيه DNS** / خوادم إعادة التوجيه | learn.microsoft.com/ar-sa/azure/azure-vmware/configure-dns-azure-vmware-solution ("تكوين معيد توجيه DNS") |
| Switch (شبكات) | المحوّل | **المبدّل** | ar.wikipedia.org/wiki/مبدل_(شبكات) — في Microsoft تعني «محوّل» بطاقة الشبكة (adapter) |
| DHCP lease | عقد / مدة الإيجار | **عقد الإيجار / مدة التأجير** | learn.microsoft.com/ar-sa/training/modules/deploy-manage-dynamic-host-configuration-protocol/ |
| Bandwidth | عرض النطاق | **عرض النطاق الترددي** | learn.microsoft.com/ar-sa/azure/vpn-gateway/vpn-gateway-about-vpngateways |
| Firmware | البرامج الثابتة / البرنامج الثابت | **البرنامج الثابت** (توحيد) | support.microsoft.com/ar-sa/surface/drivers-firmware/how-to-use-surface-uefi |
| Certificate Authority | جهة إصدار الشهادات | **المرجع المصدق** | learn.microsoft.com/ar-sa/azure/security/fundamentals/azure-certificate-authority-details (المصطلح نفسه في واجهة Windows) |
| Authorization | التفويض | **التخويل** | learn.microsoft.com/ar-sa/azure/iot-hub/iot-hub-tls-support ، learn.microsoft.com/ar-sa/azure/app-service/configure-authentication-oauth-tokens |
| Plugin | الإضافة | **المكوّن الإضافي** | learn.microsoft.com/ar-sa/power-platform/alm/plugin-component |
| Threshold | الحد | **العتبة** (يبقى «الحد» لمعنى limit) | learn.microsoft.com/ar-sa/azure/application-gateway/application-gateway-probe-overview |
| Entry (عنصر قائمة) | المدخل / الإدخال | **الإدخال** — في Microsoft تعني «مدخل» كلمة portal | صفحات Microsoft أعلاه |
| Whitelist / Blacklist | القائمة البيضاء / السوداء | **قائمة السماح / قائمة الحظر** | help.eset.com/ees/7/ar-EG/idh_panel_smon_edit_wlbl.html |
| Realm | النطاق (realm) | **نطاق المصادقة (Realm)** | لا يوجد مصطلح معياري؛ أُضيف قيد يمنع الخلط مع «النطاق» بمعنى domain |

## مصطلحات تم تأكيدها (بقيت كما هي)

- **مصطلحات الشبكات:**
  - جدار الحماية، البوابة، البوابة الافتراضية
  - الشبكة الفرعية، قناع الشبكة الفرعية، البادئة
  - التوجيه، المسار الثابت، النفق
  - فقدان الحزم، المنفذ، إعادة توجيه المنافذ
  - المحلّل، الحجز، القاعدة، ذو حالة / عديم الحالة
  - تجاوز الفشل، الوكيل / الوكيل العكسي
  - اسم المضيف، النظير، البث / البث المتعدد
  - الواجهة، الموجّه، الجسر
- **مصطلحات الأمان:**
  - قائمة إبطال الشهادات، طلب توقيع الشهادة
  - المفتاح الخاص / العام، التجزئة، البصمة
  - التشفير، المصادقة، بيانات الاعتماد
  - كلمة مرور لمرة واحدة، المصادقة الثنائية
  - كشف / منع التسلل، قائمة الحظر
- **مصطلحات الواجهة والنظام:**
  - لوحة المعلومات، الأداة، الذاكرة المؤقتة، السجل
  - المهلة، الفاصل الزمني، تطبيق، تجاوز
  - المرآة، النسخ الاحتياطي / الاستعادة
  - مدة التشغيل، إعادة التشغيل
  - الترويسة، الحمولة، المصافحة

## قرارات مقصودة بخلاف Microsoft (مع السبب)

- **Domain = «النطاق»** وليس «المجال»:
  - ويكيبيديا العربية وICANN ومسجّلو النطاقات العرب يستخدمون «اسم النطاق».
  - صفحات Microsoft المترجمة آليًا نفسها غير متسقة بين «المجال» و«النطاق».
- **Enable = «تفعيل»** وليس «تمكين»:
  - الأكثر شيوعًا في واجهات Google وAndroid وApple.
  - موحّد في كل الترجمة، أكثر من 560 موضعًا.
- **Regular expression = «التعبير النمطي»**:
  - يطابق ويكيبيديا العربية، ومطبّق باتساق.
- **Token = «الرمز»**:
  - السياق دائمًا واضح (رمز API، رمز OTP).
  - «الرمز المميز» يطيل النصوص القصيرة دون فائدة.
- **Load balancing = «موازنة الحمل»** و**Offload = «التفريغ»**:
  - الصيغتان موجودتان في صفحات Microsoft نفسها.

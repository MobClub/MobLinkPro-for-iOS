Pod::Spec.new do |s|
	s.name                = "mob_linksdk_pro"
	s.version             = "3.3.2"
	s.summary             = 'mob.com网页一键唤醒App并到达指定内页SDK,原Pod名称为:MobLink,请知悉～'
	s.license             = 'Copyright © 2012-2017 mob.com'
	s.author              = { "MobProducts" => "mobproducts@163.com" }
	s.homepage            = 'http://www.mob.com'
	s.source              = { :http => 'https://dev.ios.mob.com/files/download/moblinkpro/MobLinkPro_For_iOS_v3.3.2.zip' }
	s.platform            = :ios, '8.0'
	s.frameworks          = "ImageIO", "JavaScriptCore"
	s.libraries           = "icucore", "z", "c++", "sqlite3"
	s.vendored_frameworks = 'MobLinkPro/MobLinkPro.framework'
	s.dependency 'MOBFoundation'
end

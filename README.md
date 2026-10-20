# plugin.service.emby-next-gen

## ⚠️ Disclaimer / 免责声明 ⚠️


This is **NOT** the official repository for the `emby-next-gen` Kodi add-on. This is a personal project/fork containing custom modifications and optimizations.   
*Note: This specific branch/repository was primarily created to provide compatibility and support for the [vfs.stream.fast](https://github.com/forbxy/vfs.stream.fast) add-on.*

For official downloads, support, updates, and discussions, please visit the official Emby Kodi community forum at:
👉 **[https://emby.media/community/forum/185-emby-for-kodi-next-gen/](https://emby.media/community/forum/185-emby-for-kodi-next-gen/)**


本仓库**不是** `emby-next-gen` Kodi 插件的官方代码库。这是一个包含自定义修改和优化的个人项目/分支。  
*注：创建此分支/仓库的主要目的是为了支持并兼容 [vfs.stream.fast](https://github.com/forbxy/vfs.stream.fast) 插件。*

如需获取官方原版插件下载、技术支持、最新更新或参与讨论，请访问官方的 Emby Kodi 社区论坛：
👉 **[https://emby.media/community/forum/185-emby-for-kodi-next-gen/](https://emby.media/community/forum/185-emby-for-kodi-next-gen/)**

---

## 播放ISO的说明

要支持 ISO 等格式播放，请必须先安装配套的 vfs 插件：
[vfs.stream.fast](https://github.com/forbxy/vfs.stream.fast)

安装完 vfs 插件并本插件后，使用next-gen插件模式，默认设置。

假设strm内的url是 `https://192.168.1.1:5244/A/B/C?arg1=D&arg2=E`
假设strm文件的存放路径 `/F/G/H/J.strm`

只需要保证 **A B C D E F G H J** 里有任意一个是以 `.格式` 结尾的就行。

如果实在没法保证，**设置-同步**里还有一个选项：
**STRM从最终url获取视频格式**

打开后，当无法从emby元数据、strm文件路径以及url中获取格式时，
通过HEAD请求strm文件内的url拿取最终下载地址并获取格式。

> ⚠️ 这会导致同步变慢，短时大量获取下载地址也可能被云服务商风控，谨慎使用。

## 自动发布

先将 `addon.xml` 的版本号更新并提交，再推送相同版本的 tag，例如：

```bash
git tag v12.4.15.11
git push origin v12.4.15.11
```

也支持不带 `v` 的 tag。GitHub Actions 会校验版本、打包，并将 ZIP 上传到对应的 GitHub Release；重新运行时会替换同名附件。tag 与 `addon.xml` 版本不一致时，发布会失败。

本地打包仍使用 `python build_package.py`，输出到 `dist/`。压缩包顶层目录固定为插件 ID，GitHub 工作流不会打入安装包。

## License

许可证为 GNU GPL v2，与 `addon.xml` 中的声明一致。

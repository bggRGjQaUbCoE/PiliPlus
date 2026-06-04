# Phase 1 Manual Acceptance User Original Feedback

Date: 2026-05-31

## Scope

- Repo: `CometDash77/PiliAvalon-Worksite`
- Branch: `phase-1-shielding-core`
- Acceptance package under test: `phase-1-prebuild.26680259984`
- Feedback role: user is the customer / 甲方.
- Status: manual acceptance is not green. Startup and several flows pass, but acceptance found functional and UX gaps.

## Customer Original Text

The following block is the user's original feedback text. Preserve it as primary acceptance evidence, not a paraphrase.

```text
1.同样的包我装过了所以当然没问题，但是上一个commit跟这个commit还是冲突状态 2.没闪退没白 3.up主改变的还是不对，屏蔽用户关键词means，针对用户这个分类下，屏蔽所有用户id里带这个词的操作，但是目前的系统，把用户名当作普通关键词的一种，不满意，而且，我希望是在piliplus上游的那种长按卡片有显示封面的方式魔改，目前的不够美观，但是有屏蔽uid的选项这个对了 6.相关视频也生效了，但是标签屏蔽没有作用，我期望的是标签屏蔽的效果在推荐流生效，但是程序似乎没有这样的读取，请问是逻辑问题吗？推荐流不识别视频的标签，所以是不点进去不识别吗？need factcheck 7.有用了，但是是同样的问题，上游的屏蔽功能和新增的屏蔽系统同时在生效，不需要这样，上游的功能合并到这个屏蔽系统里 8.可以，但是我需要设置也的分类页，方便整理 9.可以 10.也可以
```

## Interpreted Acceptance Results

- Cover install: not newly proven by this pass, because the same package had already been installed before.
- Startup: pass. User reports no crash and no white screen.
- UP shielding: incomplete. UID shielding option is correct, but "user keyword" semantics are not accepted.
- Card long-press UX: incomplete. User expects an upstream PiliPlus-style long-press card experience that keeps / shows the cover preview and is visually more polished.
- Related videos: pass / partially pass. User reports related-video shielding works.
- Tag shielding in recommendation feed: failed or unclear. User expects tag shielding to affect recommendation feed; needs technical fact-check on whether recommendation feed payload exposes tags before opening details.
- Comment shielding: partially pass. User reports it works, but legacy upstream shielding and the new shielding system are both active; user wants the upstream function merged into the new shielding system instead of duplicated.
- Shielding settings page: partially pass. User can use it, but wants categorized settings pages for organization.
- Global switch: pass.
- Restart persistence: pass.

## Required Follow-Up

- Do not mark Phase 1 manual acceptance green from this feedback.
- Preserve this record as the customer original feedback source.
- Send a design-institute / technical-lead review request that explicitly states the request includes the user's original text.
- Fact-check recommendation-feed tag data availability before deciding whether tag shielding failure is implementation logic, unavailable upstream data, or a product-scope question.

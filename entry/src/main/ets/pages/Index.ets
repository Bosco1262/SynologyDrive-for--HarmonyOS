interface SidebarItem {
  key: string;
  icon: string;
  title: string;
}

interface SyncFileItem {
  id: string;
  name: string;
  type: string;
  location: string;
  size: string;
  modified: string;
  owner: string;
  status: string;
}

const SIDEBAR_ITEMS: SidebarItem[] = [
  { key: 'home', icon: '🏠', title: '主页' },
  { key: 'files', icon: '📁', title: '我的文件' },
  { key: 'team', icon: '👥', title: '团队空间' },
  { key: 'recent', icon: '🕘', title: '最近' },
  { key: 'offline', icon: '📌', title: '离线文件' },
  { key: 'tasks', icon: '🔄', title: '同步任务' }
];

const FILE_ITEMS: SyncFileItem[] = [
  {
    id: 'f1',
    name: '产品需求文档_v5.docx',
    type: 'Word 文档',
    location: '/Work/Product',
    size: '2.1 MB',
    modified: '今天 10:42',
    owner: 'Bosco',
    status: '已同步'
  },
  {
    id: 'f2',
    name: 'DesignSystem.sketch',
    type: 'Sketch 文件',
    location: '/Work/Design',
    size: '84.3 MB',
    modified: '今天 09:15',
    owner: 'Alina',
    status: '正在同步'
  },
  {
    id: 'f3',
    name: 'Roadmap_2026.xlsx',
    type: 'Excel 表格',
    location: '/Team/Strategy',
    size: '3.4 MB',
    modified: '昨天 19:21',
    owner: 'Kevin',
    status: '冲突'
  },
  {
    id: 'f4',
    name: 'release_notes.md',
    type: 'Markdown',
    location: '/Work/Release',
    size: '128 KB',
    modified: '昨天 16:03',
    owner: 'Bosco',
    status: '已同步'
  },
  {
    id: 'f5',
    name: 'presentation_final.pptx',
    type: 'PowerPoint',
    location: '/Share/Meetings',
    size: '26.9 MB',
    modified: '04-11 21:08',
    owner: 'Amy',
    status: '等待网络'
  },
  {
    id: 'f6',
    name: 'demo_video.mp4',
    type: '视频',
    location: '/Media/Demo',
    size: '1.2 GB',
    modified: '04-10 08:32',
    owner: 'Jason',
    status: '暂停'
  }
];

@Entry
@Component
struct Index {
  @State activeSidebar: string = 'files';
  @State selectedFileId: string = 'f1';
  @State searchText: string = '';
  @State listMode: boolean = true;
  @State isSyncing: boolean = false;

  private get selectedFile(): SyncFileItem {
    const found = FILE_ITEMS.find((item: SyncFileItem) => item.id === this.selectedFileId);
    return found ? found : FILE_ITEMS[0];
  }

  private get visibleFiles(): SyncFileItem[] {
    const keyword = this.searchText.trim().toLowerCase();
    if (!keyword) {
      return FILE_ITEMS;
    }
    return FILE_ITEMS.filter((item: SyncFileItem) =>
      item.name.toLowerCase().includes(keyword) || item.location.toLowerCase().includes(keyword));
  }

  private statusColor(status: string): string {
    if (status === '已同步') {
      return '#22C55E';
    }
    if (status === '正在同步') {
      return '#3B82F6';
    }
    if (status === '冲突') {
      return '#EF4444';
    }
    return '#F59E0B';
  }

  @Builder
  private renderTitleBar() {
    Row() {
      Row({ space: 10 }) {
        Text('☁️')
          .fontSize(20)
        Column({ space: 2 }) {
          Text('Synology Drive')
            .fontSize(16)
            .fontWeight(FontWeight.Medium)
            .fontColor('#111827')
          Text('HarmonyOS 桌面端风格')
            .fontSize(11)
            .fontColor('#6B7280')
        }
      }

      Blank()

      TextInput({ text: $$this.searchText, placeholder: '搜索文件、路径或成员' })
        .width(320)
        .height(36)
        .fontSize(13)
        .backgroundColor('#F9FAFB')
        .borderRadius(10)
        .border({ width: 1, color: '#E5E7EB' })
        .padding({ left: 10, right: 10 })

      Row({ space: 8 }) {
        Button(this.listMode ? '列表视图' : '网格视图')
          .height(34)
          .fontSize(12)
          .backgroundColor('#EEF2FF')
          .fontColor('#4338CA')
          .borderRadius(8)
          .onClick(() => {
            this.listMode = !this.listMode;
          })
        Button(this.isSyncing ? '同步中...' : '立即同步')
          .height(34)
          .fontSize(12)
          .backgroundColor(this.isSyncing ? '#93C5FD' : '#2563EB')
          .fontColor('#FFFFFF')
          .borderRadius(8)
          .onClick(() => {
            this.isSyncing = !this.isSyncing;
          })
      }
    }
    .height(64)
    .width('100%')
    .padding({ left: 16, right: 16 })
    .backgroundColor('#FFFFFF')
    .border({ width: 1, color: '#E5E7EB' })
  }

  @Builder
  private renderSidebar() {
    Column({ space: 6 }) {
      ForEach(SIDEBAR_ITEMS, (item: SidebarItem) => {
        Row({ space: 10 }) {
          Text(item.icon)
            .fontSize(16)
          Text(item.title)
            .fontSize(13)
            .fontColor(this.activeSidebar === item.key ? '#1D4ED8' : '#374151')
            .fontWeight(this.activeSidebar === item.key ? FontWeight.Medium : FontWeight.Normal)
          Blank()
        }
        .width('100%')
        .height(40)
        .padding({ left: 12, right: 10 })
        .backgroundColor(this.activeSidebar === item.key ? '#E0EAFF' : '#F8FAFC')
        .borderRadius(8)
        .onClick(() => {
          this.activeSidebar = item.key;
        })
      }, (item: SidebarItem) => item.key)

      Blank()

      Column({ space: 8 }) {
        Text('存储空间')
          .width('100%')
          .fontSize(12)
          .fontColor('#6B7280')
        Progress({ value: 67, total: 100, type: ProgressType.Linear })
          .width('100%')
          .height(6)
          .color('#2563EB')
          .backgroundColor('#E5E7EB')
        Text('67% 已使用 · 1.34 TB / 2 TB')
          .width('100%')
          .fontSize(11)
          .fontColor('#6B7280')
      }
      .padding(12)
      .backgroundColor('#FFFFFF')
      .borderRadius(10)
    }
    .width('100%')
    .height('100%')
    .padding(10)
    .backgroundColor('#F8FAFC')
  }

  @Builder
  private renderFilePanel() {
    Column({ space: 0 }) {
      Row() {
        Text('名称')
          .layoutWeight(3)
          .fontSize(12)
          .fontColor('#6B7280')
        Text('位置')
          .layoutWeight(2)
          .fontSize(12)
          .fontColor('#6B7280')
        Text('大小')
          .layoutWeight(1)
          .fontSize(12)
          .fontColor('#6B7280')
        Text('修改时间')
          .layoutWeight(2)
          .fontSize(12)
          .fontColor('#6B7280')
        Text('状态')
          .layoutWeight(1)
          .fontSize(12)
          .fontColor('#6B7280')
      }
      .height(42)
      .padding({ left: 14, right: 14 })
      .backgroundColor('#F9FAFB')
      .border({ width: 1, color: '#E5E7EB' })

      List({ space: 4 }) {
        ForEach(this.visibleFiles, (item: SyncFileItem) => {
          ListItem() {
            Row() {
              Row({ space: 8 }) {
                Text('📄').fontSize(14)
                Text(item.name)
                  .fontSize(13)
                  .fontColor('#111827')
                  .maxLines(1)
                  .textOverflow({ overflow: TextOverflow.Ellipsis })
              }
              .layoutWeight(3)

              Text(item.location)
                .layoutWeight(2)
                .fontSize(12)
                .fontColor('#4B5563')
                .maxLines(1)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
              Text(item.size)
                .layoutWeight(1)
                .fontSize(12)
                .fontColor('#4B5563')
              Text(item.modified)
                .layoutWeight(2)
                .fontSize(12)
                .fontColor('#4B5563')

              Row({ space: 6 }) {
                Text('●')
                  .fontSize(10)
                  .fontColor(this.statusColor(item.status))
                Text(item.status)
                  .fontSize(12)
                  .fontColor('#374151')
              }
              .layoutWeight(1)
            }
            .height(46)
            .padding({ left: 14, right: 14 })
            .backgroundColor(this.selectedFileId === item.id ? '#E8F0FF' : '#FFFFFF')
            .borderRadius(8)
            .onClick(() => {
              this.selectedFileId = item.id;
            })
          }
        }, (item: SyncFileItem) => item.id)
      }
      .layoutWeight(1)
      .padding(6)
      .backgroundColor('#FFFFFF')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 12, color: '#0F172A12', offsetX: 0, offsetY: 4 })
  }

  @Builder
  private renderDetailPanel() {
    Column({ space: 10 }) {
      Text('详细信息')
        .fontSize(14)
        .fontWeight(FontWeight.Medium)
        .fontColor('#111827')
      Divider().color('#E5E7EB')

      Text(this.selectedFile.name)
        .fontSize(13)
        .fontWeight(FontWeight.Medium)
        .fontColor('#111827')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      this.renderDetailRow('类型', this.selectedFile.type)
      this.renderDetailRow('归属', this.selectedFile.owner)
      this.renderDetailRow('位置', this.selectedFile.location)
      this.renderDetailRow('大小', this.selectedFile.size)
      this.renderDetailRow('修改时间', this.selectedFile.modified)
      this.renderDetailRow('同步状态', this.selectedFile.status)

      Blank()

      Button('查看历史版本')
        .width('100%')
        .height(36)
        .fontSize(12)
        .backgroundColor('#EEF2FF')
        .fontColor('#4338CA')
        .borderRadius(8)

      Button('分享链接')
        .width('100%')
        .height(36)
        .fontSize(12)
        .backgroundColor('#F3F4F6')
        .fontColor('#374151')
        .borderRadius(8)
    }
    .width('100%')
    .height('100%')
    .padding(12)
    .backgroundColor('#FFFFFF')
    .borderRadius(12)
    .shadow({ radius: 12, color: '#0F172A12', offsetX: 0, offsetY: 4 })
  }

  @Builder
  private renderDetailRow(label: string, value: string) {
    Row() {
      Text(label)
        .layoutWeight(1)
        .fontSize(12)
        .fontColor('#6B7280')
      Text(value)
        .layoutWeight(2)
        .fontSize(12)
        .fontColor('#111827')
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
    }
  }

  @Builder
  private renderBottomBar() {
    Row() {
      Text(this.isSyncing ? '同步引擎状态：正在执行增量同步...' : '同步引擎状态：空闲')
        .fontSize(12)
        .fontColor('#374151')
      Blank()
      Text(`当前目录共 ${this.visibleFiles.length} 个项目`)
        .fontSize(12)
        .fontColor('#6B7280')
    }
    .width('100%')
    .height(36)
    .padding({ left: 16, right: 16 })
    .backgroundColor('#F9FAFB')
    .border({ width: 1, color: '#E5E7EB' })
  }

  build() {
    Column({ space: 0 }) {
      this.renderTitleBar()
      Row({ space: 10 }) {
        Column() {
          this.renderSidebar()
        }
        .width('20%')
        .height('100%')

        Column() {
          this.renderFilePanel()
        }
        .width('56%')
        .height('100%')

        Column() {
          this.renderDetailPanel()
        }
        .width('24%')
        .height('100%')
      }
      .layoutWeight(1)
      .padding(10)

      this.renderBottomBar()
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#EEF2F7')
  }
}

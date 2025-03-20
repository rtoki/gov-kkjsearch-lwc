import { LightningElement, track } from 'lwc';
import searchWorks from '@salesforce/apex/KkjSearchController.searchWorks';

export default class WorksSearch extends LightningElement {
    @track query = '';
    @track projectName = '';
    @track organizationName = '';
    @track count = 10;
    @track category = '';  // カテゴリーの値（初期は未選択）
    @track results;
    @track isModalOpen = false;
    @track selectedWork;

    // カテゴリーの選択リストのオプション
    get categoryOptions() {
        return [
            { label: '未選択', value: '' },
            { label: '物品', value: '1' },
            { label: '工事', value: '2' },
            { label: '役務', value: '3' }
        ];
    }

    handleQueryChange(event) {
        this.query = event.target.value;
    }
    handleProjectNameChange(event) {
        this.projectName = event.target.value;
    }
    handleOrganizationNameChange(event) {
        this.organizationName = event.target.value;
    }
    handleCountChange(event) {
        this.count = event.target.value;
    }
    handleCategoryChange(event) {
        this.category = event.detail.value;
    }

    handleSearch() {
        if (!this.query && !this.projectName && !this.organizationName) {
            alert('検索文字列、件名、または機関名のいずれか一つを指定してください。');
            return;
        }
        searchWorks({
            query: this.query,
            projectName: this.projectName,
            organizationName: this.organizationName,
            count: this.count,
            category: this.category
        })
            .then(data => {
                this.results = data;
            })
            .catch(error => {
                console.error('API呼び出しエラー: ', error);
            });
    }

    handleShowDetails(event) {
        const workId = event.currentTarget.dataset.id;
        this.selectedWork = this.results.find(work => work.resultId === workId);
        this.isModalOpen = true;
    }

    handleCloseModal() {
        this.isModalOpen = false;
        this.selectedWork = null;
    }
}
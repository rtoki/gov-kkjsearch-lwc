public with sharing class KkjSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Work> searchWorks(String query, String projectName, String organizationName, Integer count, String category) {
        // 少なくとも検索文字列、件名、または機関名のいずれか一つが指定されているかチェック
        if (String.isBlank(query) && String.isBlank(projectName) && String.isBlank(organizationName)) {
            throw new AuraHandledException('検索文字列、件名、または機関名のいずれか一つを指定してください。');
        }
        if (count == null) {
            count = 10;
        }
        
        // URL 組み立て
        String endpoint = 'https://www.kkj.go.jp/api/?';
        List<String> params = new List<String>();
        if (!String.isBlank(query)) {
            params.add('Query=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        }
        if (!String.isBlank(projectName)) {
            params.add('Project_Name=' + EncodingUtil.urlEncode(projectName, 'UTF-8'));
        }
        if (!String.isBlank(organizationName)) {
            params.add('Organization_Name=' + EncodingUtil.urlEncode(organizationName, 'UTF-8'));
        }
        if (!String.isBlank(category)) {
            params.add('Category=' + EncodingUtil.urlEncode(category, 'UTF-8'));
        }
        params.add('Count=' + count);
        endpoint += String.join(params, '&');
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');
        
        Http http = new Http();
        HTTPResponse res = http.send(req);
        
        if (res.getStatusCode() == 200) {
            String body = res.getBody();
            List<Work> works = new List<Work>();
            
            // XML レスポンスのパース
            Dom.Document doc = new Dom.Document();
            doc.load(body);
            Dom.XmlNode root = doc.getRootElement();  // <Results>
            Dom.XmlNode searchResults = root.getChildElement('SearchResults', null);
            if (searchResults != null) {
                for (Dom.XmlNode node : searchResults.getChildElements()) {
                    if (node.getName() == 'SearchResult') {
                        Work w = new Work();
                        w.resultId = getChildText(node, 'ResultId');
                        w.key = getChildText(node, 'Key');
                        w.externalDocumentURI = getChildText(node, 'ExternalDocumentURI');
                        w.projectName = getChildText(node, 'ProjectName');
                        w.projectDate = getChildText(node, 'Date'); // 予約語 "date" の代わりに projectDate
                        w.fileType = getChildText(node, 'FileType');
                        w.fileSize = getChildText(node, 'FileSize');
                        w.lgCode = getChildText(node, 'LgCode');
                        w.prefectureName = getChildText(node, 'PrefectureName');
                        w.organizationName = getChildText(node, 'OrganizationName');
                        w.cftIssueDate = getChildText(node, 'CftIssueDate');
                        w.procedureType = getChildText(node, 'ProcedureType');
                        w.projectDescription = getChildText(node, 'ProjectDescription');
                        works.add(w);
                    }
                }
            }
            return works;
        } else {
            throw new AuraHandledException('API call failed: ' + res.getStatus());
        }
    }
    
    // ヘルパーメソッド：指定した子要素のテキストを取得。CDATA マーカーが含まれていれば除去する
    private static String getChildText(Dom.XmlNode parent, String childName) {
        Dom.XmlNode child = parent.getChildElement(childName, null);
        if (child != null) {
            String text = child.getText();
            text = text.trim();
            if (text != null && text.contains('<![CDATA[')) {
                text = text.replace('<![CDATA[', '').replace(']]>', '');
            }
            return text.trim();
        }
        return '';
    }
    
    // API のレスポンスに合わせたラッパークラス
    public class Work {
        @AuraEnabled public String resultId;
        @AuraEnabled public String key;
        @AuraEnabled public String externalDocumentURI;
        @AuraEnabled public String projectName;
        @AuraEnabled public String projectDate;
        @AuraEnabled public String fileType;
        @AuraEnabled public String fileSize;
        @AuraEnabled public String lgCode;
        @AuraEnabled public String prefectureName;
        @AuraEnabled public String organizationName;
        @AuraEnabled public String cftIssueDate;
        @AuraEnabled public String procedureType;
        @AuraEnabled public String projectDescription;
    }
}
require 'nokogiri'
require 'open-uri'
require 'date'
require 'csv'
require 'mail'

class ScrapesController < ApplicationController
    def index
    end
    
    def execute
        # 本日の日付を取得
        presentDate = Date.today.strftime("%a, %-d %b %Y")
#        presentDate = "Mon, 30 Dec 2019"
        # 詳細ページのベースURL
        urlBase = "https://arxiv.org/abs/"
        # 各論文pdfページへのベースURL
        urlPdf = "https://arxiv.org/pdf/"
        # 論文IDを格納する配列
        paperIds = []
        # 各論文pdfページへURLを格納する配列
        paperPdfs = []
        # 論文のタイトルを格納する配列
        titles = []
        # 論文の著者を格納する配列
        authors = []
        # 論文のアブストを格納する配列
        abstracts = []
        # 著者名の一時保存用配列
        tmpAuthors = []

        # 論文一覧ページのスクレイピング
        urlIndex = 'https://arxiv.org/list/astro-ph.EP/recent'
        charset = nil
        pageIndex = open(urlIndex) do |f|
            charset = f.charset
            f.read
        end
        # 今日アップされた論文のID一覧を取得
        docIndex = Nokogiri::HTML.parse(pageIndex, nil, charset)
        docIndex.xpath('//*[@id="dlpage"]').each do |node|
            lastDate = node.at_css('h3').inner_text
            if lastDate==presentDate then
                content = node.at_css('dl').css('.list-identifier').css('a').inner_text.gsub("pdf", " ").gsub("ps", " ").gsub("other", " ").gsub!("arXiv:", " ")
                paperIds = content.split        
            end
        end
        # 各論文のタイトル、著者、アブスト、pdfを取得
        paperIds.each do |id|
            urlAbst = urlBase + id
            paperPdfs.push(urlPdf + id)
            pageAbst = open(urlAbst) do |f|
                charset = f.charset
                f.read
            end
            docAbst = Nokogiri::HTML.parse(pageAbst, nil, charset)
            docAbst.xpath('//div[@id="abs"]').each do |node|
                title = node.css('.title').inner_text.gsub("Title:", "///")
                tmp = title.split("///")
                titles.push(tmp[1])
            end
            tmpAuthors = []
            docAbst.xpath('//div[@id="abs"]').each do |node|
                author = node.css(".authors").css('a').inner_text
                tmpAuthors.push(author)
            end
            authors.push(tmpAuthors)
            docAbst.xpath('//div[@id="abs"]').each do |node|
                abstract = node.css('.abstract').inner_text.gsub("Abstract: ", "")
                abstracts.push(abstract)
            end
        end
        # 著者名を２次元から１次元配列へ
        authorList = []
        authors.each do |x|
            authorList.push(x.join(", "))
        end
        # ActionMailerによるメール送信
        ScrapeMailer.send_mail(presentDate, titles, authors, abstracts, paperPdfs).deliver
    end
end

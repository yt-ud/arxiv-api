class ScrapeMailer < ApplicationMailer
    def send_mail(date, titles, authors, abstracts, abstracts_ja, urlpdfs)
        @date = date
        @titles = titles
        @authors = authors
        @abstracts = abstracts
        @abstracts_ja = abstracts_ja
        @urlpdfs = urlpdfs
        mail(
          from: 'scrapearxiv@gmail.com',
          to:   'yuta.u1969@gmail.com',
          subject: @date + "arxiv.org/astro-ph.EP"
        )
    end
end

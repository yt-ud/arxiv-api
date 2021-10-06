class ScrapeMailer < ApplicationMailer
    def send_mail(date, titles, authors, abstracts, urlpdfs)
        @date = date
        @titles = titles
        @authors = authors
        @abstracts = abstracts
        @urlpdfs = urlpdfs
        mail(
          from: 'scrapearxiv@gmail.com',
          to:   'yufrom2018@gmail.com',
          cc:   'yuta.u1969@gmail.com',
          subject: @date + "arxiv.org/astro-ph.EP"
        )
    end
end

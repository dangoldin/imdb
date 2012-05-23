import requests
from BeautifulSoup import BeautifulSoup

import time
import MySQLdb
db = MySQLdb.connect(user='root',passwd='',db='imdb')
c = db.cursor()

base_url = 'http://www.imdb.com'

top_base = 'http://www.imdb.com/chart/%ss'
top_urls = [ top_base % x for x in range(1910,2012,10)]

movie_base = 'http://www.imdb.com/title/%s/fullcredits#cast'

actor_base = 'http://www.imdb.com/name/%s/'

def processTopPage(url):
    data = requests.get(url)
    soup = BeautifulSoup(data.content)
    table = soup.find(id='main').find('table')
    movies = []
    for row in table.findAll('tr'):
        tds = row.findAll('td')
        if tds[2].a:
            rank = tds[0].text
            rating = tds[1].text
            title = tds[2].text
            url = tds[2].find('a').get('href')
            votes = tds[3].text
            movies.append({'rank':int(float(rank)),
                            'rating':float(rating),
                            'title':title,
                            'url':url,
                            'votes':int(votes.replace(',','')),
                            })
    return movies

def processMovie(url):
    data = requests.get(url)
    soup = BeautifulSoup(data.content)
    cast = []
    year = None
    for link in soup.find('h1').findAll('a'):
        if '/year/' in link.get('href'):
            year = link.text
    for row in soup.find('table','cast').findAll('tr'):
        actor = row.find('td','nm')
        if actor:
            cast.append({'url': actor.find('a').get('href'),
                         'name': actor.text,
                        })
    return {'cast':cast,
            'year':year
            }

def processActor(url):
    data = requests.get(url)
    soup = BeautifulSoup(data.content)
    role = soup.find('div','infobar').find('a').text
    dates = soup.find(id='name-overview-widget-layout').find('div','txt-block').findAll('time')
    born = died = None
    for date in dates:
        if date.get('itemprop') == 'birthDate':
            born = date.get('datetime')
    return {'role' : role,
            'birth' : born,
            'death' : died,
            }

def getOrSaveMovie(name,url,year):
    c.execute("""SELECT * FROM movies WHERE url = %s""", (url,))
    row = c.fetchone()
    if row is None:
        print 'Creating movie'
        c.execute("""INSERT INTO movies (name,url,year) VALUES (%s,%s,%s)""", (name,url,year))
        return {
            'id' : int(c.lastrowid),
            'name': name,
            'url' : url,
            'year' : year,
        }
    else:
        print 'Retrieved movie'
        return {
            'id': int(row[0]),
            'name': row[1],
            'url': row[2],
            'year': row[3],
        }

def getOrSaveActor(name,url,role,birth_date,death_date):
    c.execute("""SELECT * FROM actors WHERE url = %s""", (url,))
    row = c.fetchone()
    if row is None:
        print 'Creating actor'
        # if death_date is not None:
        c.execute("""INSERT INTO actors (name,url,role,birth_date,death_date) VALUES (%s,%s,%s,%s,%s)""", (name,url,role,birth_date,death_date))
        # else:
        #     c.execute("""INSERT INTO actors (name,url,role,birth_death) VALUES (%s,%s,%s)""", (name,url,role,birth_date,death_date))
        return {
            'id' : int(c.lastrowid),
            'name': name,
            'url': url,
            'role' : role,
            'birth_date': birth_date,
            'death_date': death_date,
        }
    else:
        print 'Retrieved actor'
        return {
            'id': int(row[0]),
            'name': row[1],
            'url': row[2],
            'role': row[3],
            'birth_date': row[4],
            'death_date': row[5],
        }

def getOrSaveMovieActor(actor_id,movie_id):
    c.execute("""SELECT * FROM movie_actors WHERE actor_id = %s and movie_id = %s""", (actor_id,movie_id))
    row = c.fetchone()
    if row is None:
        print 'Creating actor movie'
        c.execute("""INSERT INTO movie_actors (actor_id,movie_id) VALUES (%s,%s)""", (actor_id,movie_id))
        return {
            'id' : int(c.lastrowid),
            'actor_id': actor_id,
            'movie_id': movie_id,
        }
    else:
        print 'Retrieved actor movie'
        return {
            'id': int(row[0]),
            'actor_id': row[1],
            'movie_id': row[2],
        }

for top_url in top_urls[-1:]:
    print 'Processing List:', top_url
    movies = processTopPage(top_url)
    for movie in movies:
        print 'Processing Movie:', movie['title'], movie
        movie_url = movie['url']
        movie_info = processMovie(base_url + movie_url + 'fullcredits')
        year = movie_info['year']
        print movie['title'],'in',year
        movie_db = getOrSaveMovie(movie['title'], movie_url, year)
        cast = movie_info['cast']
        for actor in cast[:5]:
            try:
                actor_url = actor['url']
                actor_info = processActor(base_url + actor_url)
                actor_info['name'] = actor['name']
                actor_info['url'] = actor_url
                print actor_info
                actor_db = getOrSaveActor(actor_info['name'],actor_info['url'],actor_info['role'],actor_info['birth'],actor_info['death'])
                am_db = getOrSaveMovieActor(actor_db['id'],movie_db['id'])
            except Exception, e:
                print 'Failed getting actor: ',actor['name'],actor_url
            time.sleep(1)
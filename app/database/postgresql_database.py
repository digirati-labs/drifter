import psycopg2
import psycopg2.extras
import abc
from .base import Database
from logzero import logger

class PostgreSqlDatabase(Database):

    def initialise(self, settings):
        logger.info("postgresql_database: initialise()")
        con = None

        create = False

        self.connection_string = "dbname='%s' user='%s' host='%s' password='%s'" % \
            (settings["dbname"], settings["user"], settings["host"], settings["password"])

        try:
            con = psycopg2.connect(self.connection_string)
            cur = con.cursor()
            cur.execute("SELECT * FROM active")
        except psycopg2.Error:
            # no active table
            create = True
        finally:
            if con:
                con.close()

        if create:
            self.create_schema()
        else:
            logger.info("postgresql_database: schema ready")


    def create_schema(self):
        logger.debug("postgresql_database: create_schema()")
        con = None

        try:
            con = psycopg2.connect(self.connection_string)
            cur = con.cursor()
            cur.execute("CREATE TABLE active (environment_group CHARACTER VARYING(500) NOT NULL, environment CHARACTER VARYING(500) NOT NULL, endpoint_group CHARACTER VARYING(500) NOT NULL, endpoint CHARACTER VARYING(500) NOT NULL, timestamp INTEGER NOT NULL, message CHARACTER VARYING(500) NOT NULL, url CHARACTER VARYING(500) NOT NULL)")
            con.commit()
        except psycopg2.Error as e:
            logger.error("postgresql_database: problem during create_schema() - %s" % str(e))
        finally:
            if con:
                con.close()
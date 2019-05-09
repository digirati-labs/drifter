import sqlite3
import abc
from .base import Database

from logzero import logger

class SqliteDatabase(Database):

    def initialise(self, settings):
        logger.info("sqlite_database: initialise()")
        con = None

        create = False

        self.db_name = settings["db_name"]

        try:
            con = sqlite3.connect(self.db_name)
            cur = con.cursor()
            cur.execute("SELECT * FROM active")
            _ = cur.fetchone()
        except sqlite3.Error:
            # no active table
            create = True
        finally:
            if con:
                con.close()

        if create:
            self.create_schema()
        else:
            logger.info("sqlite_database: schema ready")


    def create_schema(self):
        logger.debug("sqlite_database: create_schema()")
        con = None

        try:
            con = sqlite3.connect(self.db_name)
            cur = con.cursor()
            cur.execute("CREATE TABLE active (environment_group TEXT, environment TEXT, endpoint_group TEXT, endpoint TEXT, timestamp INTEGER, message TEXT, url TEXT)")
            con.commit()
        except sqlite3.Error as e:
            logger.error("sqlite_database: problem during create_schema() - %s" % str(e))
        finally:
            if con:
                con.close()
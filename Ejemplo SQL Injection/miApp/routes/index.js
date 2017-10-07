var express = require('express');
var router = express.Router();
var mysql = require('mysql');
var MongoClient = require('mongodb').MongoClient;
var async = require('async');
var sanitize = require('mongo-sanitize');

var connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'C0l0mb31a.2021',
  database: 'estudiante_db'
});
 connection.connect();
/* GET home page. */
router.get('/', function (req, res, next) {
  res.render('index', { title: 'Express' });
});

router.post('/buscar', function (req, res, next) {
 

  var idEstudiante = req.body.idEstudiante;
  var sql = "SELECT * FROM Estudiantes WHERE idEstudiante = " + idEstudiante;

  connection.query(sql, function (error, results, fields) {
    if (error) {
      throw error;
    }
    // connection.end();
    res.json(results);
  });

 
});


router.post('/buscar2', function (req, res, next) {
 

  var idEstudiante = req.body.idEstudiante;
  var sql = "SELECT * FROM Estudiantes WHERE idEstudiante = " +  connection.escape(idEstudiante);

  connection.query(sql, function (error, results, fields) {
    if (error) {
      throw error;
    }
    // connection.end();
    res.json(results);
  });

 
});


router.post('/buscar3', function (req, res, next) {
 

  var idEstudiante = req.body.idEstudiante;
  var sql = "SELECT * FROM Estudiantes WHERE idEstudiante = ?";

  connection.query(sql,[idEstudiante], function (error, results, fields) {
    if (error) {
      throw error;
    }
    // connection.end();
    res.json(results);
  });

 
});

router.post('/buscar4', function (req, res, next) {

  MongoClient.connect("mongodb://localhost:27017/pruebaEstudiante", function (err, db) {
    if (err) { return console.dir(err); }

    var query = { "idEstudiante": req.body.idEstudiante };
    console.log(query);
    var collection = db.collection('estudiantes');
    collection.find(query).toArray(function (error, documents) {
      if (err) throw error;

      res.send(documents);
    });
  });


});


router.post('/buscar5', function (req, res, next) {

  MongoClient.connect("mongodb://localhost:27017/pruebaEstudiante", function (err, db) {
    if (err) { return console.dir(err); }

    var query = { "idEstudiante": sanitize(req.body.idEstudiante) };
    console.log(query);
    var collection = db.collection('estudiantes');
    collection.find(query).toArray(function (error, documents) {
      if (err) throw error;

      res.send(documents);
    });
  });


});




module.exports = router;

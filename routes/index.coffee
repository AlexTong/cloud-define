express = require 'express'
router = express.Router()

# GET home page.
router.get '/', (req, res, next) ->
	res.render 'index',
		title: 'Express'
# GET home page.
router.get '/sortable', (req, res, next) ->
	res.render 'sortable',
		title: 'Express'
module.exports = router

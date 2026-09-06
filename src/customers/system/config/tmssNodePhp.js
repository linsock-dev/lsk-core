module.exports = function(req, res, next) {
  const lc_clttkn = req.headers['x-internal-token'];
  const lc_srvtkn = process.env.INTERNAL_TOKEN;

  if (!lc_clttkn) {
    return res.status(401).json({ status: "error", message: "Token no enviado" });
  }

  if (lc_clttkn !== lc_srvtkn) {
    return res.status(403).json({ status: "error", message: "Token inválido" });
  }

  next();
};
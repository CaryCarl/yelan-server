const express = require("express");
const router = express.Router();
const utils = require("../../utils/index.js");
const { systemSettings } = require("../../utils/menuString");
const pools = require("../../utils/pools.js");
const svgCaptcha = require('svg-captcha');

//获取图形二维码
router.post("/getCaptcha", async (req, res) => {
    const captcha = svgCaptcha.create({
        inverse: false, // 翻转颜色
        fontSize: 48, // 字体大小
        width: 110, // 宽度
        height: 36, // 高度
        size: 4, // 验证码长度
        ignoreChars: '0oO1iIg', // 验证码字符中排除 0o1i
        color: true, // 验证码是否有彩色
        noise: 3, // 干扰线几条
        background: '#e2e2e2', // 验证码图片背景颜色
    });
    res.setHeader('Access-Control-Expose-Headers', 'captcha');
    let captchaToken = utils.setToken({ captcha: captcha.text.toLowerCase(), name: "captcha" });
    res.setHeader('captcha', captchaToken);
    res.send(utils.returnData({ data: captcha.data }))
});

//登录
router.post("/login", async (req, res) => {
    let sql = "SELECT id,admin,more_id FROM user WHERE name=? AND pwd=?", { name, pwd, captcha } = req.body;
    let captchaRes = utils.verToken({ token: req.headers.captcha, name: "captcha" });
    console.log("captchaRes---", captchaRes)
    console.log("captcha---", captcha.toLowerCase())
    if (!captchaRes || captchaRes.captcha !== captcha.toLowerCase()){
        return res.send(utils.returnData({ code: -1, msg: "验证码错误！！！", req }));
    }
    let { result } = await pools({ sql, val: [name, pwd], res, req });
    if (result.length === 0) return res.send(utils.returnData({ code: -1, msg: "请输入正确的用户名和密码！", req }));
    let uid = result[0].id, admin = result[0].admin;
    let token = utils.setToken({ uid });
    res.send(utils.returnData({ data: { uid, name, token, admin } }));
});

//获取用户信息
router.post("/getUserInfo", async (req, res) => {
    let user = await utils.getUserRole(req, res);
    let sql = `SELECT b.menu_bg AS menuBg,b.menu_sub_bg AS menuSubBg,b.menu_text AS menuText,b.menu_active_text AS menuActiveText,b.menu_sub_active_text AS menuSubActiveText,b.menu_hover_bg AS menuHoverBg FROM theme AS b WHERE user_id=?`;
    let { result } = await pools({ sql, val: [user.user.id], res, req });
    res.send(utils.returnData({ data: { ...user, theme: result[0] } }));
    
})

function getRouter(req, res, sidebar = false) {
    return new Promise(async (resolve, reject) => {
        let sql = "SELECT id,parent_id AS parentId,path,hidden,redirect,always_show AS alwaysShow,name,layout,parent_view AS parentView,meta,component,sort,alone,role_key AS roleKey,menu_type AS menuType,title,icon,no_cache AS noCache,update_time AS updateTime,create_time AS createTime FROM router_menu WHERE 1=1";
        sql += " ORDER BY sort ASC, update_time DESC"
        let userRole = await utils.getUserRole(req, res);
        if (userRole == -1) return res.send(utils.returnData({ code: -1, req }));
        if (!userRole.userRole || userRole.userRole == null || userRole.userRole == "null") userRole.userRole = "";
        //角色权限
        let roles = userRole.userRole.split(",");
        let { result } = await pools({ sql, res, req });
        // console.log(result )
        let list = [...result], routerArr = [];
        let filterAsyncRoutes = (lists, parentId, pathView = "") => {
            let resArr = [], obj = {};
            lists.map((t) => {
                let objs = { ...t };
                try { objs.meta = JSON.parse(objs.meta); } catch (err) { objs.meta = {}; }
                objs.meta.title = objs.title;
                objs.meta.icon = objs.icon;
                objs.meta.noCache = objs.noCache;
                objs.pathView = t.path;
                //按钮自动隐藏
                if (objs.menuType === "F") objs.hidden = 1;
                //递归
                if (objs.parentId == parentId) {
                    objs.path = pathView + objs.path;
                    obj = { ...objs, children: filterAsyncRoutes(list, objs.id, objs.path) };
                    //菜单下有子级，单独拿出来
                    if (obj.menuType === "C" && obj.children && obj.children.length != 0) {
                        routerArr.push(...obj.children)
                        sidebar && delete obj.children;
                    }
                    //如果是总管理
                    if (userRole.user.admin == 1 || userRole.roleAdmin) { resArr.push(obj); } else {
                        //只拿角色权限通过的
                        if (roles.some((role) => obj.id == role)) resArr.push(obj);
                    }
                }
            });
            return resArr;
        };
        let routerMenu = filterAsyncRoutes(list, 0, "");
        //如果是独立的（一级）
        sidebar && routerMenu.forEach(t => {
            if (t.menuType === "C" && (!t.children || t.children.length === 0)) {
                t.layout = 1;
                t.children = [{ ...t, layout: 0, alone: 1, children: undefined, }]
                t.path = "/" + Math.random();
            }
        });
        
        resolve({ routerMenu, routerArr })

    })
}
//获取路由 侧边栏
router.post("/getRouter", async (req, res) => {
    let { routerMenu, routerArr } = await getRouter(req, res, true);
    function bianpinghua(list) {
        let arr = [];
        list.map(t => {
            if (t.children && t.children.length) arr.push(...bianpinghua(t.children))
            arr.push({ ...t, layout: 1, path: "/" + Math.random(), children: [{ ...t, layout: 0, alone: 1, children: undefined }], hidden: 1 });
        })
        return arr
    }
    routerArr = bianpinghua(routerArr);
    routerArr = routerArr.filter((obj, index, self) => index === self.findIndex((t) => (t.id === obj.id)));
    res.send(utils.returnData({ data: { routerMenu: routerMenu.concat(routerArr) } }))
});

//添加用户
router.post("/addUser", async (req, res) => {
    await utils.checkPermi({ req, res, role: [systemSettings.user.userAdd] });
    let sql = "INSERT INTO user(name,status,roles_id,remark,pwd,more_id,url) VALUES (?,?,?,?,?,?,?)", obj = req.body;
    await utils.existName({ sql: "SELECT id FROM user WHERE  name=?", name: obj.name, res, msg: "用户名已被使用！", req });
    let { result } = await pools({ sql, val: [obj.name, obj.status, obj.rolesId, obj.remark, obj.pwd, obj.moreId, obj.url || ""], res, req });
    let themeSql = "INSERT INTO theme(user_id,menu_bg,menu_sub_bg,menu_text,menu_active_text,menu_sub_active_text,menu_hover_bg) VALUES (?,?,?,?,?,?,?)";
    await pools({ sql: themeSql, val: [result.insertId, "#304156", "#304156", "#bfcad5", "#409eff", "#fff", "#001528"], res, req, run: false });
});

//查询用户
router.post("/getUser", async (req, res) => {
    await utils.checkPermi({ req, res, role: [systemSettings.user.userQuery] });
    let obj = req.body;
    let sql = `SELECT a.id AS id,name,status,roles_id AS rolesId,remark,admin,more_id AS moreId,url,a.update_time AS updateTime,a.create_time AS createTime,b.menu_bg AS menuBg,b.menu_sub_bg AS menuSubBg,b.menu_text AS menuText,b.menu_active_text AS menuActiveText,b.menu_sub_active_text AS menuSubActiveText,b.menu_hover_bg AS menuHoverBg FROM user AS a LEFT JOIN theme b ON a.id=b.user_id WHERE 1=1`;
    sql = utils.setLike(sql, "name", obj.name);
    let { total } = await utils.getSum({ sql, name: "user", res, req });
    sql += ` ORDER BY id ASC`;
    sql = utils.pageSize(sql, obj.page, obj.size);
    let { result } = await pools({ sql, res, req });
    res.send(utils.returnData({ data: result, total }));
});

//修改用户
router.post("/upUser", async (req, res) => {
    await utils.checkPermi({ req, res, role: [systemSettings.user.userUp] });
    let sql = "UPDATE  user SET name=?,status=?,roles_id=?,remark=?,more_id=?,url=? WHERE id=?", obj = req.body;
    //总管理不能操作
    await utils.upAdmin({ req, res, id: obj.id });
    let judgeUserNameRes = await utils.judgeUserName({ sql: "SELECT name FROM user WHERE  id=?", name: obj.name, id: obj.id, req, res });
    if (judgeUserNameRes === 1) await utils.existName({ sql: "SELECT id FROM user WHERE  name=?", name: obj.name, res, msg: "用户名已被使用！", req });
    await pools({ sql, val: [obj.name, obj.status, obj.rolesId, obj.remark, obj.moreId, obj.url, obj.id], res, req, run: false });
});

//修改我的信息
router.post("/upUserInfo", async (req, res) => {
    // await utils.checkPermi({req,res,role:[systemSettings.user.userUp]});
    let user = await utils.getUserInfo({ req, res });
    let sql = "UPDATE  user SET name=?,url=? WHERE id=?", obj = req.body;
    let judgeUserNameRes = await utils.judgeUserName({ sql: "SELECT name FROM user WHERE  id=?", name: obj.name, id: user.id, req, res });
    if (judgeUserNameRes === 1) await utils.existName({ sql: "SELECT id FROM user WHERE  name=?", name: obj.name, res, msg: "登陆账号已被使用！", req });
    await pools({ sql, val: [obj.name, obj.url, user.id], res, req, run: false });
});


//修改我的信息密码
router.post("/upUserPwdInfo", async (req, res) => {
    // await utils.checkPermi({req,res,role:[systemSettings.user.userPwd]});
    let user = await utils.getUserInfo({ req, res });
    let sql = "UPDATE  user SET pwd=? WHERE id=?", obj = req.body;
    await pools({ sql, val: [obj.pwd, user.id], res, req, run: false });
});


//修改用户密码
router.post("/upUserPwd", async (req, res) => {
    await utils.checkPermi({ req, res, role: [systemSettings.user.userPwd] });
    let sql = "UPDATE  user SET pwd=? WHERE id=?", obj = req.body;
    let getUserIdRes = await utils.getUserId({ id: obj.id, req, res });
    if (getUserIdRes.admin === 1) {
        let user = await utils.getUserInfo({ req, res });
        if (user.admin !== 1) return res.send(utils.returnData({ code: -1, msg: "总管理密码只能总管理账号修改！", req }));
    }
    await pools({ sql, val: [obj.pwd, obj.id], res, req, run: false });
});

//删除用户
router.post("/delUser", async (req, res) => {
    await utils.checkPermi({ req, res, role: [systemSettings.user.userDelte] });
    let obj = req.body;
    //总管理不能操作
    await utils.upAdmin({ req, res, id: obj.id });
    let user = await utils.getUserInfo({ req, res });
    if (obj.id == user.id) return res.send(utils.returnData({ code: -1, msg: "无法删除正在使用中的用户~", req }));
    let sql = "DELETE FROM user WHERE id=?";
    await pools({ sql, val: [obj.id], res, req, run: false });
});


module.exports = router;

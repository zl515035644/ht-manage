import http from '@/utils/request'

/**
 * 用户登陆方法
 * @param data
 * @returns {*}
 */
export async function login(data) {
  return http.login("/api/user/login", data);
}
export async function getInfo() {
  return http.get("/api/sysUser/getInfo");
}
export async function logout(param) {
  return http.post("/api/sysUser/logout", param);
}

export async function getMenuList() {
  return http.get("/api/sysUser/getMenuList");
}
// export function login(data) {
//   return request({
//     url: '/vue-element-admin/user/login',
//     method: 'post',
//     data
//   })
// }
//
// export function getInfo(token) {
//   return request({
//     url: '/vue-element-admin/user/info',
//     method: 'get',
//     params: { token }
//   })
// }
//
// export function logout() {
//   return request({
//     url: '/vue-element-admin/user/logout',
//     method: 'post'
//   })
// }

import http from '@/utils/request'

export function getRoutes() {

}

export async function getRoles(data) {
  return http.get("/api/role/list", data);
}

export async function addRole(data) {
  return http.post("/api/role/add", data);
}

export async function updateRole(data) {
  return http.put("/api/role/update", data);
}

//检查角色是否被使用
export async function checkRole(data) {
  return http.getRestApi("/api/role/check", data);
}
//删除角色
export function deleteRole(data) {
  return http.delete("/api/role/delete", data);
}
export function getAssignTree(data) {
  return http.get("/api/role/getAssignPermissionTree", data);
}
export function saveRoleAssign(data) {
  return http.post("/api/role/saveRoleAssign", data);
}

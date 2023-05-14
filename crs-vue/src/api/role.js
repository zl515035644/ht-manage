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

export function deleteRole(id) {

}

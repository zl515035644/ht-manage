import http from '@/utils/request'

export function getRoutes() {

}

export async function getRoles(params) {
  return http.get("/api/role/list", params);
}

export function addRole(data) {

}

export function updateRole(id, data) {

}

export function deleteRole(id) {

}

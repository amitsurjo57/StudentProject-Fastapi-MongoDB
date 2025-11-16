from fastapi import FastAPI, HTTPException, status
from pymongo import AsyncMongoClient
from myutils import DATABASE_URL, DATABASE_NAME
from student_model import StudentModel


def main(dept_name: str):
    client = AsyncMongoClient(DATABASE_URL)
    db = client.get_database(DATABASE_NAME)
    students_coll_dept = db.get_collection(dept_name)

    return client, students_coll_dept


app = FastAPI()


@app.get('/')
def root():
    return "This is a student app"


@app.post('/students/{dept_name}')
async def create_student_by_dept(dept_name: str, student: StudentModel):
    dept_name = dept_name.upper()

    try:

        client, students_coll_dept = main(dept_name)

        student['department'] = dept_name

        await students_coll_dept.insert_one(student)

        await client.close()

        return 'New student added successfully'


    except HTTPException:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Bad Request")


@app.get('/students/{dept_name}')
async def get_students_by_dept(dept_name: str):
    dept_name = dept_name.upper()

    try:
        client, students_coll_dept = main(dept_name)

        student_list = []

        students = students_coll_dept.find()

        async for student in students:
            model = StudentModel(
                name=student['name'],
                department=student['department'],
                roll=student['roll'],
                section=student['section'],
                phone=student['phone']
            )

            student_list.append({
                '_id': str(student['_id']),
                'data': model
            })

        await client.close()

        return student_list

    except HTTPException:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST)


@app.get('/students/{dept_name}/{roll}')
async def find_student(dept_name: str, roll: int):
    dept_name = dept_name.upper()

    try:
        client, students_coll_dept = main(dept_name)

        student = await students_coll_dept.find_one({'department': dept_name, 'roll': roll})

        await client.close()

        return {
            '_id': str(student['_id']),
            'name': student['name'],
            'department': student['department'],
            'roll': student['roll'],
            'section': student['section'],
            'phone': student['phone'],
        }

    except HTTPException:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Bad Request")


@app.delete('/students/{dept_name}/{name}/{roll}')
async def delete_student(dept_name: str, name: str, roll: int):
    dept_name = dept_name.upper()

    try:
        client, students_coll_dept = main(dept_name)

        await students_coll_dept.delete_one({
            'name': name,
            'roll': roll,
        })

        await client.close()

        return "Delete Successfully"

    except HTTPException:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Bad Request")


@app.patch('/students/{dept_name}/{name}/{roll}')
async def update_student(dept_name: str, name: str, roll: int, student: StudentModel):
    dept_name = dept_name.upper()

    try:
        client, students_coll_dept = main(dept_name)

        query_op = {'name': name, 'roll': roll}
        update_op = {
            '$set': {
                'name': student['name'],
                'department': student['department'].upper(),
                'roll': student['roll'],
                'section': student['section'],
                'phone': student['phone'],
            }}

        await students_coll_dept.update_one(query_op, update_op)

        await client.close()

        return "Update Successfully"

    except HTTPException:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail="Bad Request")

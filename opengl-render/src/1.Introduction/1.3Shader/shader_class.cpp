#include <glad/glad.h>
#include <GLFW/glfw3.h>
#include <iostream>
#include "shader.h"


void framebuffer_size_callback(GLFWwindow* window, int width, int height)
{
	glViewport(0, 0, width, height);
}

void processInput(GLFWwindow* window)
{
	if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
	{
		glfwSetWindowShouldClose(window, true);
	}
}

int main()
{
	// initialize glfw
	glfwInit();
	glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3);
	glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3);
	glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE);

	// create a window object
	GLFWwindow* window = glfwCreateWindow(800, 600, "OpenGL", NULL, NULL);
	if (window == NULL)
	{
		std::cout << "Failed to create GLFW window" << std::endl;
		glfwTerminate();
		return -1;
	}
	glfwMakeContextCurrent(window);

	// glad manages function pointers
	if (!gladLoadGLLoader((GLADloadproc)glfwGetProcAddress))
	{
		std::cout << "Failed to initialize GLAD" << std::endl;
		return -1;
	}

	// resize render resolution
	glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

	// build and compile our shader program
	// ------------------------------------
	Shader myShader = Shader("3.3vertex.vs", "3.3fragment.fs");

	// set up vertex data (and buffer(s)) and configure vertex attributes
	// ------------------------------------------------------------------
	// vertex(NDC SPACE)
	// index drawing
	//float vertices[] = {
	//	0.5f, 0.5f, 0.0f,   // right upper
	//	0.5f, -0.5f, 0.0f,  // right lower
	//	-0.5f, -0.5f, 0.0f, // left lower
	//	-0.5f, 0.5f, 0.0f   // left upper
	//};
	//unsigned int indices[] = {
	//	// 注意索引从0开始! 
	//	// 此例的索引(0,1,2,3)就是顶点数组vertices的下标，
	//	// 这样可以由下标代表顶点组合成矩形
	//	0, 1, 3, // 第一个三角形
	//	1, 2, 3  // 第二个三角形
	//};
	float verticesOne[] = {
	-0.5f, 0.0f, 0.0f,	1.0f, 0.0f, 0.0f, // from 0-2 is vertex, from 3-5 is color(custom vertex attribute)
	-0.25f, 0.5f, 0.0f, 0.0f, 1.0f, 0.0f,
	0.0f, 0.0f, 0.0f,	0.0f, 0.0f, 1.0f,
	};
	float verticesTwo[] = {
	0.5f, 0.0f, 0.0f,	1.0f, 0.0f, 1.0f,
	0.25f, 0.5f, 0.0f,	0.0f, 0.0f, 1.0f,
	0.0f, 0.0f, 0.0f,	0.0f, 1.0f, 1.0f,
	};
	// Vertex Array Object
	// use VAO to link attributs in VBO
	unsigned int VAOs[2];
	glGenVertexArrays(2, VAOs);
	// bind VAO first
	glBindVertexArray(VAOs[0]);
	// vertex buffer object
	// Create VBO vertex buffer object, store vertex info in GPU memory, fast access
	unsigned int VBOs[2];
	glGenBuffers(2, VBOs);
	// GL_ARRAY_BUFFER is a type of buffer object
	glBindBuffer(GL_ARRAY_BUFFER, VBOs[0]);
	// Copy vertices to GL_ARRAY_BUFFER
	glBufferData(GL_ARRAY_BUFFER, sizeof(verticesOne), verticesOne, GL_STATIC_DRAW);

	// element buffer object
	//unsigned int EBO;
	//glGenBuffers(1, &EBO);
	//// bind indices to EBO
	//glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, EBO);
	//glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(indices), indices, GL_STATIC_DRAW);

	// link vertex attributes (VAO POINT TO VBO)
	// get data from GL_ARRAY_BUFFER's VBO
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
	glEnableVertexAttribArray(0); // 0 is the location, we need this to enable vertex attributes
	// color
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float))); // last parameter is offset
	glEnableVertexAttribArray(1);

	glBindVertexArray(VAOs[1]);	// note that we bind to a different VAO now
	glBindBuffer(GL_ARRAY_BUFFER, VBOs[1]);	// and a different VBO
	glBufferData(GL_ARRAY_BUFFER, sizeof(verticesTwo), verticesTwo, GL_STATIC_DRAW);
	glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0); // because the vertex data is tightly packed we can also specify 0 as the vertex attribute's stride to let OpenGL figure it out
	glEnableVertexAttribArray(0);
	// color 
	glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float))); // last parameter is offset
	glEnableVertexAttribArray(1);

	// Unbind VBO with GL_ARRAY_BUFFER
	glBindBuffer(GL_ARRAY_BUFFER, 0);
	glBindVertexArray(0);

	// render loop
	while (!glfwWindowShouldClose(window))
	{
		// input
		processInput(window);

		// renders
		glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
		glClear(GL_COLOR_BUFFER_BIT);

		//use shader
		myShader.use();

		// change global uniform variable 
		float timeValue = glfwGetTime();
		float greenValue = (sin(timeValue) / 2.0f) + 0.5f;
		//change myColor
		myShader.setVec4("myColor", greenValue, greenValue, greenValue, 1.0f);

		// bind every frame
		glBindVertexArray(VAOs[0]);
		glDrawArrays(GL_TRIANGLES, 0, 3);
		// then we draw the second triangle using the data from the second VAO
		glBindVertexArray(VAOs[1]);
		glDrawArrays(GL_TRIANGLES, 0, 3);

		//index drawing
		//glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 0);

		// check and call events and swap the buffers
		glfwSwapBuffers(window);
		glfwPollEvents();
	}

	glDeleteVertexArrays(2, VAOs);
	glDeleteBuffers(2, VBOs);
	glfwTerminate();
	return 0;
}